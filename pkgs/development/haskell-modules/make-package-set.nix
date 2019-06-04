# This expression takes a file like `hackage-packages.nix` and constructs
# a full package set out of that.

{ # package-set used for build tools (all of nixpkgs)
  buildPackages

, # A haskell package set for Setup.hs, compiler plugins, and similar
  # build-time uses.
  buildHaskellPackages

, # package-set used for non-haskell dependencies (all of nixpkgs)
  pkgs

, # stdenv to use for building haskell packages
  stdenv

, haskellLib

, # hashes for downloading Hackage packages
  all-cabal-hashes

, # compiler to use
  ghc

, # A function that takes `{ pkgs, stdenv, callPackage }` as the first arg and
  # `self` as second, and returns a set of haskell packages
  package-set

, # The final, fully overriden package set usable with the nixpkgs fixpoint
  # overriding functionality
  extensible-self
}:

# return value: a function from self to the package set
self:

let
  inherit (stdenv) buildPlatform hostPlatform;

  inherit (stdenv.lib) fix' extends makeOverridable;
  inherit (haskellLib) overrideCabal getBuildInputs;

  mkDerivationImpl = pkgs.callPackage ./generic-builder.nix {
    inherit stdenv;
    nodejs = buildPackages.nodejs-slim;
    inherit (self) buildHaskellPackages ghc shellFor;
    inherit (self.buildHaskellPackages) jailbreak-cabal;
    hscolour = overrideCabal self.buildHaskellPackages.hscolour (drv: {
      isLibrary = false;
      doHaddock = false;
      hyperlinkSource = false;      # Avoid depending on hscolour for this build.
      postFixup = "rm -rf $out/lib $out/share $out/nix-support";
    });
    cpphs = overrideCabal (self.cpphs.overrideScope (self: super: {
      mkDerivation = drv: super.mkDerivation (drv // {
        enableSharedExecutables = false;
        enableSharedLibraries = false;
        doHaddock = false;
        useCpphs = false;
      });
    })) (drv: {
        isLibrary = false;
        postFixup = "rm -rf $out/lib $out/share $out/nix-support";
    });
  };

  mkDerivation = makeOverridable mkDerivationImpl;

  # manualArgs are the arguments that were explictly passed to `callPackage`, like:
  #
  # callPackage foo { bar = null; };
  #
  # here `bar` is a manual argument.
  callPackageWithScope = scope: fn: manualArgs:
    let
      # this code is copied from callPackage in lib/customisation.nix
      #
      # we cannot use `callPackage` here because we want to call `makeOverridable`
      # on `drvScope` (we cannot add `overrideScope` after calling `callPackage` because then it is
      # lost on `.override`) but determine the auto-args based on `drv` (the problem here
      # is that nix has no way to "passthrough" args while preserving the reflection
      # info that callPackage uses to determine the arguments).
      drv = if stdenv.lib.isFunction fn then fn else import fn;
      auto = builtins.intersectAttrs (stdenv.lib.functionArgs drv) scope;

      # this wraps the `drv` function to add a `overrideScope` function to the result.
      drvScope = allArgs: drv allArgs // {
        overrideScope = f:
          let newScope = mkScope (fix' (extends f scope.__unfix__));
          # note that we have to be careful here: `allArgs` includes the auto-arguments that
          # weren't manually specified. If we would just pass `allArgs` to the recursive call here,
          # then we wouldn't look up any packages in the scope in the next interation, because it
          # appears as if all arguments were already manually passed, so the scope change would do
          # nothing.
          in callPackageWithScope newScope drv manualArgs;
      };
    in stdenv.lib.makeOverridable drvScope (auto // manualArgs);

  mkScope = scope: let
      ps = pkgs.__splicedPackages;
      scopeSpliced = pkgs.splicePackages {
        pkgsBuildBuild = scope.buildHaskellPackages.buildHaskellPackages;
        pkgsBuildHost = scope.buildHaskellPackages;
        pkgsBuildTarget = {};
        pkgsHostHost = {};
        pkgsHostTarget = scope;
        pkgsTargetTarget = {};
      } // {
        # Don't splice these
        inherit (scope) ghc buildHaskellPackages;
      };
    in ps // ps.xorg // ps.gnome2 // { inherit stdenv; } // scopeSpliced;
  defaultScope = mkScope self;
  callPackage = drv: args: callPackageWithScope defaultScope drv args;

  withPackages = packages: buildPackages.callPackage ./with-packages-wrapper.nix {
    inherit (self) ghc llvmPackages;
    inherit packages;
  };

  haskellSrc2nix = { name, src, sha256 ? null, extraCabal2nixOptions ? "" }:
    let
      sha256Arg = if isNull sha256 then "--sha256=" else ''--sha256="${sha256}"'';
    in pkgs.buildPackages.stdenv.mkDerivation {
      name = "cabal2nix-${name}";
      nativeBuildInputs = [ pkgs.buildPackages.cabal2nix ];
      preferLocalBuild = true;
      allowSubstitutes = false;
      phases = ["installPhase"];
      LANG = "en_US.UTF-8";
      LOCALE_ARCHIVE = pkgs.lib.optionalString (buildPlatform.libc == "glibc") "${buildPackages.glibcLocales}/lib/locale/locale-archive";
      installPhase = ''
        export HOME="$TMP"
        mkdir -p "$out"
        cabal2nix --compiler=${self.ghc.haskellCompilerName} --system=${hostPlatform.system} ${sha256Arg} "${src}" ${extraCabal2nixOptions} > "$out/default.nix"
      '';
  };

  all-cabal-hashes-component = name: version: pkgs.runCommand "all-cabal-hashes-component-${name}-${version}" {} ''
    tar --wildcards -xzvf ${all-cabal-hashes} \*/${name}/${version}/${name}.{json,cabal}
    mkdir -p $out
    mv */${name}/${version}/${name}.{json,cabal} $out
  '';

  hackage2nix = name: version: let component = all-cabal-hashes-component name version; in self.haskellSrc2nix {
    name   = "${name}-${version}";
    sha256 = ''$(sed -e 's/.*"SHA256":"//' -e 's/".*$//' "${component}/${name}.json")'';
    src    = "${component}/${name}.cabal";
  };

  # Adds a nix file as an input to the haskell derivation it
  # produces. This is useful for callHackage / callCabal2nix to
  # prevent the generated default.nix from being garbage collected
  # (requiring it to be frequently rebuilt), which can be an
  # annoyance.
  callPackageKeepDeriver = src: args:
    overrideCabal (self.callPackage src args) (orig: {
      preConfigure = ''
        # Generated from ${src}
        ${orig.preConfigure or ""}
      '';
      passthru = orig.passthru or {} // {
        # When using callCabal2nix or callHackage, it is often useful
        # to debug a failure by inspecting the Nix expression
        # generated by cabal2nix. This can be accessed via this
        # cabal2nixDeriver field.
        cabal2nixDeriver = src;
      };
    });

in package-set { inherit pkgs stdenv callPackage; } self // {

    inherit mkDerivation callPackage haskellSrc2nix hackage2nix buildHaskellPackages;

    inherit (haskellLib) packageSourceOverrides;

    callHackage = name: version: callPackageKeepDeriver (self.hackage2nix name version);

    # This function does not depend on all-cabal-hashes and therefore will work
    # for any version that has been released on hackage as opposed to only
    # versions released before whatever version of all-cabal-hashes you happen
    # to be currently using.
    callHackageDirect = {pkg, ver, sha256}@args:
      let pkgver = "${pkg}-${ver}";
      in self.callCabal2nix pkg (pkgs.fetchzip {
           url = "mirror://hackage/${pkgver}/${pkgver}.tar.gz";
           inherit sha256;
         });

    # Creates a Haskell package from a source package by calling cabal2nix on the source.
    callCabal2nixWithOptions = name: src: extraCabal2nixOptions: args:
      let
        filter = path: type:
                   pkgs.lib.hasSuffix "${name}.cabal" path ||
                   baseNameOf path == "package.yaml";
        expr = self.haskellSrc2nix {
          inherit name extraCabal2nixOptions;
          src = if pkgs.lib.canCleanSource src
                  then pkgs.lib.cleanSourceWith { inherit src filter; }
                else src;
        };
      in overrideCabal (callPackageKeepDeriver expr args) (orig: {
           inherit src;
         });

    callCabal2nix = name: src: args: self.callCabal2nixWithOptions name src "" args;

    # : { root : Path
    #   , name : Defaulted String
    #   , source-overrides : Defaulted (Either Path VersionNumber)
    #   , overrides : Defaulted (HaskellPackageOverrideSet)
    #   , modifier : Defaulted
    #   , returnShellEnv : Defaulted
    #   } -> NixShellAwareDerivation
    # Given a path to a haskell package directory, an optional package name
    # which defaults to the base name of the path, an optional set of source
    # overrides as appropriate for the 'packageSourceOverrides' function, an
    # optional set of arbitrary overrides, and an optional haskell package
    # modifier, return a derivation appropriate for nix-build or nix-shell to
    # build that package.
    developPackage =
      { root
      , name ? builtins.baseNameOf root
      , source-overrides ? {}
      , overrides ? self: super: {}
      , modifier ? drv: drv
      , returnShellEnv ? pkgs.lib.inNixShell }:
      let drv =
        (extensible-self.extend
           (pkgs.lib.composeExtensions
              (self.packageSourceOverrides source-overrides)
              overrides))
        .callCabal2nix name root {};
      in if returnShellEnv then (modifier drv).env else modifier drv;

    ghcWithPackages = selectFrom: withPackages (selectFrom self);

    ghcWithHoogle = selectFrom:
      let
        packages = selectFrom self;
        hoogle = callPackage ./hoogle.nix {
          inherit packages;
        };
      in withPackages (packages ++ [ hoogle ]);

    # Returns a derivation whose environment contains a GHC with only
    # the dependencies of packages listed in `packages`, not the
    # packages themselves. Using nix-shell on this derivation will
    # give you an environment suitable for developing the listed
    # packages with an incremental tool like cabal-install.
    #
    #     # default.nix
    #     with import <nixpkgs> {};
    #     haskellPackages.extend (haskell.lib.packageSourceOverrides {
    #       frontend = ./frontend;
    #       backend = ./backend;
    #       common = ./common;
    #     })
    #
    #     # shell.nix
    #     (import ./.).shellFor {
    #       packages = p: [p.frontend p.backend p.common];
    #       withHoogle = true;
    #     }
    #
    #     -- cabal.project
    #     packages:
    #       frontend/
    #       backend/
    #       common/
    #
    #     bash$ nix-shell --run "cabal new-build all"
    shellFor = { packages, withHoogle ? false, ... } @ args:
      let
        selected = packages self;

        packageInputs = map getBuildInputs selected;

        name = if pkgs.lib.length selected == 1
          then "ghc-shell-for-${(pkgs.lib.head selected).name}"
          else "ghc-shell-for-packages";

        # If `packages = [ a b ]` and `a` depends on `b`, don't build `b`,
        # because cabal will end up ignoring that built version, assuming
        # new-style commands.
        haskellInputs = pkgs.lib.filter
          (input: pkgs.lib.all (p: input.outPath != p.outPath) selected)
          (pkgs.lib.concatMap (p: p.haskellBuildInputs) packageInputs);
        systemInputs = pkgs.lib.concatMap (p: p.systemBuildInputs) packageInputs;

        withPackages = if withHoogle then self.ghcWithHoogle else self.ghcWithPackages;
        ghcEnv = withPackages (p: haskellInputs);
        nativeBuildInputs = pkgs.lib.concatMap (p: p.nativeBuildInputs) selected;

        ghcCommand' = if ghc.isGhcjs or false then "ghcjs" else "ghc";
        ghcCommand = "${ghc.targetPrefix}${ghcCommand'}";
        ghcCommandCaps= pkgs.lib.toUpper ghcCommand';

        mkDrvArgs = builtins.removeAttrs args ["packages" "withHoogle"];
      in pkgs.stdenv.mkDerivation (mkDrvArgs // {
        name = mkDrvArgs.name or name;

        buildInputs = systemInputs ++ mkDrvArgs.buildInputs or [];
        nativeBuildInputs = [ ghcEnv ] ++ nativeBuildInputs ++ mkDrvArgs.nativeBuildInputs or [];
        phases = ["installPhase"];
        installPhase = "echo $nativeBuildInputs $buildInputs > $out";
        LANG = "en_US.UTF-8";
        LOCALE_ARCHIVE = pkgs.lib.optionalString (stdenv.hostPlatform.libc == "glibc") "${buildPackages.glibcLocales}/lib/locale/locale-archive";
        "NIX_${ghcCommandCaps}" = "${ghcEnv}/bin/${ghcCommand}";
        "NIX_${ghcCommandCaps}PKG" = "${ghcEnv}/bin/${ghcCommand}-pkg";
        # TODO: is this still valid?
        "NIX_${ghcCommandCaps}_DOCDIR" = "${ghcEnv}/share/doc/ghc/html";
        "NIX_${ghcCommandCaps}_LIBDIR" = if ghc.isHaLVM or false
          then "${ghcEnv}/lib/HaLVM-${ghc.version}"
          else "${ghcEnv}/lib/${ghcCommand}-${ghc.version}";
      });

    # This uses stack2nix to create a .nix file corresponding to a Haskell
    # package set for a Stack project.  This .nix file can either be copied
    # into your project and used as-is, or it can be used directly with the
    # callStack2nixPkgSet function.
    #
    # This function is meant for easily creating a package set for building a
    # Stack-based project.
    #
    # Here's an example of how to use this:
    #
    #   haskellPackages.callStack2nix {
    #     name = "purescript";
    #     src = fetchFromGitHub {
    #       owner = "purescript";
    #       repo = "purescript";
    #       rev = "v0.12.4";
    #       sha256 = "0lgfmqrn2j1fipgghxrccd9n5f8sw1ncc7fb25201z6x3klzy7bb";
    #     };
    #     sha256 = "1in80b914h46hsscdvkmfz0042181lxy2cj522gzyc36l4qq560w";
    #     hackageSnapshotTimestamp = "2019-05-06T00:00:00Z";
    #     compiler = haskell.compiler.ghc864;
    #   };
    #
    # This creates a .nix file containing a Haskell package set with Haskell
    # package versions determined by the LTS used to build PureScript.  This
    # example is using LTS-13.12 (which is determined by the stack.yaml file in
    # the purescript repo).
    #
    # See the callStack2nixPkgSet for how to import and build this resulting
    # package set.
    #
    # In general, this function won't be used within nixpkgs, but instead
    # by end-users who want an easy way to build a stack-based project with nix.
    #
    # This produces a fixed-output derivation.  See the comment on the sha256
    # argument for a little more info about this.  This means that
    # callStack2nix is suited for building Haskell tools, but not suited for
    # interactive development on Haskell projects.
    #
    # For instance, with the PureScript example above, callStack2nix is
    # convenient to use if you're working on a frontend project written in
    # PureScript, and you need the PureScript compiler available in your
    # environment.  However, callStack2nix should not be used if you want to
    # hack on the PureScript compiler itself.
    #
    # WARNING: Currently this doesn't work for stack.yaml files that have
    # extra-deps that are specified as git repos, HTTP(S) URLs, etc.
    #
    # An example non-working stack.yaml file would look like the following:
    #
    #   resolver: lts-13.17
    #   packages:
    #     - .
    #   extra-deps:
    #     - git: 'https://github.com/ekmett/lens.git'
    #       commit: '867f1ff48d2576b4d7cf50d1f971ce5496650a47'
    #     - http://hackage.haskell.org/package/conduit-1.3.1.1/conduit-1.3.1.1.tar.gz
    #
    # This stack.yaml will not work with callStack2nix because the lens and
    # conduit extra-deps are specified as a git repo and HTTP URL.
    #
    # The following is a similar stack.yaml file that will work with
    # callStack2nix:
    #
    #   resolver: lts-13.17
    #   packages:
    #     - .
    #   extra-deps:
    #     - lens-4.17.1
    #     - conduit-1.3.1.1
    #
    # This stack.yaml will work, because all the extra-deps are specified as
    # packages on Hackage.
    #
    # This is due to an unfortunate interaction between stack2nix and
    # cabal2nix.  See
    # https://github.com/NixOS/nixpkgs/pull/61067#discussion_r282447134
    # for the technical details.
    callStack2nix =
      { # The source for the Haskell package that contains a stack.yaml file.
        src
      , # Hash for the .nix file that is produced by stack2nix.
        #
        # It is not possible to know this before running stack2nix.  You are
        # suggested to first run this with a known incorrect sha256 hash, like
        # "a24341d51da6db9f9f0edcdefe185dbd7726888ec4e230855fb9871de7c07717".
        # Nix will complain that the hash is incorrect and will tell you the
        # correct hash.  Then you should fill in the correct hash and run
        # the derivation again.
        #
        # Since the derivation produced by callStack2nix is a fixed-output
        # derivation, you must be sure to update the sha256 if you update
        # src, hackageSnapshotTimestamp, compiler, etc.  If you only update
        # src (or hackageSnapshotTimestamp, etc) and don't update sha256, nix
        # won't realize that it should re-run callStack2nix.
        sha256
      , # A time stamp specifying a Hackage snapshot version.  In order to
        # make the output of stack2nix reproducible, stack2nix must always
        # look at the same state of Hackage.  This is needed because the
        # packages on Hackage are not actually immutable.
        #
        # example: "2019-04-16T00:00:00Z"
        #
        # TODO: It should be possible to use stack2nix to figure out what
        # resolver a package is using (like lts-13.7), then automatically
        # take the release date of the resolver as the
        # hackageSnapshotTimestamp.
        hackageSnapshotTimestamp
      , # Which GHC to use for stack2nix.  This needs to the GHC version
        # used the resolver in the stack.yaml file.
        #
        # example: haskell.compiler.ghc865
        compiler
      , # The name for the package.  This is only used to create the
        # derivation name for the produced .nix file.  It should either
        # be a string, or null.
        #
        # example: "purescript"
        name ? null
      , stack2nix ? buildPackages.haskellPackages.stack2nix_0_2_3
      , cabal-install ? buildPackages.cabal-install
      , stdenv ? pkgs.stdenv
      , cacert ? pkgs.cacert
      , git ? pkgs.git
      , iana-etc ? pkgs.iana-etc
      , libredirect ? pkgs.libredirect
      , doCheck ? true
      , doHaddock ? true
      , doBenchmark ? false
      }:
      assert builtins.isString hackageSnapshotTimestamp;
      stdenv.mkDerivation {
        name = "stack2nix${if isNull name then "" else "-for-" + name}.nix";

        nativeBuildInputs = [
          cabal-install
          cacert
          compiler
          git
          iana-etc
          libredirect
          stack2nix
        ];

        phases = ["installPhase"];

        LANG = "en_US.UTF-8";

        outputHashMode = "flat";
        outputHashAlgo = "sha256";
        outputHash = sha256;

        # Certificates need to be overridden for git and Haskell packages.
        GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";
        NIX_SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
        SYSTEM_CERTIFICATE_PATH = "${cacert}/etc/ssl/certs";

        installPhase = ''
          # Make sure /etc/protocols is available because the libraries stack
          # depends on use it.
          export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols
          export LD_PRELOAD=${libredirect}/lib/libredirect.so

          # Set $HOME because stack needs it.
          export HOME="$TMP"

          # Make a temporary directory.  stack2nix uses stack internally.
          # stack creates a .stack-work/ directory inside the source code
          # directory it is trying to build.  Since the source code directory
          # we are using is in /nix/store and not writable, we copy the
          # source code to a temporary directory so that stack is able to
          # create a .stack-work/ directory inside of it.
          #
          # Below, the temporary source directory is replaced with the path
          # to the actual source directory from /nix/store. The name of the
          # temporary source directory needs to be long enough so it is
          # reliably unique.
          temp_src_dir=$(mktemp -d stack2nix-temp.XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX)
          cp --no-target-directory -r ${src} $temp_src_dir
          chmod -R ugo+rwx $temp_src_dir

          # Make sure .stack-work doesn't already exist in the source directory.
          rm -rf $temp_src_dir/.stack-work

          stack2nix \
            ${pkgs.lib.optionalString doCheck "--test"} \
            ${pkgs.lib.optionalString doHaddock "--haddock"} \
            ${pkgs.lib.optionalString doBenchmark "--bench"} \
            -o $out \
            --hackage-snapshot ${hackageSnapshotTimestamp} \
            --verbose \
            --no-ensure-executables \
            $temp_src_dir

          # stack2nix creates the output nix file with a reference to the
          # temporary source directory from above.  We need to replace this
          # with the actual source directory from /nix/store.
          substituteInPlace $out --replace "$temp_src_dir" "${src}"
        '';
      };

    # This uses stack2nix to create a Haskell package set for a Stack project.
    # This package set contains all the Haskell packages defined in the Stack
    # project.
    #
    # This function is meant for easily building a Stack-based project with
    # nix.
    #
    # Here's an example of how to use this:
    #
    #   let
    #     purescriptPkgSet = haskellPackages.callStack2nixPkgSet {
    #       name = "purescript";
    #       src = fetchFromGitHub {
    #         owner = "purescript";
    #         repo = "purescript";
    #         rev = "v0.12.4";
    #         sha256 = "0lgfmqrn2j1fipgghxrccd9n5f8sw1ncc7fb25201z6x3klzy7bb";
    #       };
    #       sha256 = "1in80b914h46hsscdvkmfz0042181lxy2cj522gzyc36l4qq560w";
    #       hackageSnapshotTimestamp = "2019-05-06T00:00:00Z";
    #       haskellPackagesCompiler = haskell.packages.ghc864;
    #     };
    #   in purescriptPkgSet.purescript
    #
    # This is an example of building the PureScript compiler.
    #
    # This purescriptPkgSet is a normal Haskell package set (similar to
    # haskellPackages) that contains all the packages defined in the
    # stackage resolver from the stack.yaml file in the PureScript repo.
    # It contains packages like purescript, aeson, protolude, etc.
    #
    # If you want to override some of the packages used to build PureScript,
    # you can do it the same way you'd normally override Haskell packages.
    #
    # See the callStack2nix function for some of the limitations of this
    # approach.
    callStack2nixPkgSet =
      { # callStack2nix produces a derivation that takes a nix package set
        # as an argument.  This pkgs argument is passed to that derivation.
        # By default, it uses the nixpkgs that contains this function.
        pkgs ? pkgs
      , # Which Haskell package set to use for stack2nix.  This needs to the GHC
        # version used in the resolver in the stack.yaml file.  This is passed to
        # the derivation created from stack2nix and overridden with the Haskell
        # package versions from the generated .nix file.
        #
        # example: haskell.packages.ghc865
        haskellPackagesCompiler
      , # Additional arguments are the same as those for the callStack2nix
        # function.
        ...
      }@args:
      let
        callStack2nixArgs =
          builtins.removeAttrs args ["pkgs" "haskellPackagesCompiler"] // {
            compiler = haskellPackagesCompiler.ghc;
          };

        pkgSetNixFileDrv = self.callStack2nix callStack2nixArgs;

        pkgSet = import pkgSetNixFileDrv {
          inherit pkgs;
          compiler = haskellPackagesCompiler;
        };

      in pkgSet;

    ghc = ghc // {
      withPackages = self.ghcWithPackages;
      withHoogle = self.ghcWithHoogle;
    };

  }
