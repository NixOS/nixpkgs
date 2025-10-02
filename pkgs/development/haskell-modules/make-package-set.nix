# This expression takes a file like `hackage-packages.nix` and constructs
# a full package set out of that.

{
  # package-set used for build tools (all of nixpkgs)
  buildPackages,

  # A haskell package set for Setup.hs, compiler plugins, and similar
  # build-time uses.
  buildHaskellPackages,

  # package-set used for non-haskell dependencies (all of nixpkgs)
  pkgs,

  # stdenv provides our build and host platforms
  stdenv,

  # this module provides the list of known licenses and maintainers
  lib,

  # needed for overrideCabal & packageSourceOverrides
  haskellLib,

  # hashes for downloading Hackage packages
  # This is either a directory or a .tar.gz containing the cabal files and
  # hashes of Hackage as exemplified by this repository:
  # https://github.com/commercialhaskell/all-cabal-hashes/tree/hackage
  all-cabal-hashes,

  # compiler to use
  ghc,

  # A function that takes `{ pkgs, lib, callPackage }` as the first arg and
  # `self` as second, and returns a set of haskell packages
  package-set,

  # The final, fully overridden package set usable with the nixpkgs fixpoint
  # overriding functionality
  extensible-self,
}:

# return value: a function from self to the package set
self:

let
  inherit (stdenv) buildPlatform hostPlatform;

  inherit (lib) fix' extends makeOverridable;
  inherit (haskellLib) overrideCabal;

  mkDerivationImpl = pkgs.callPackage ./generic-builder.nix {
    inherit stdenv;
    nodejs = buildPackages.nodejs-slim;
    inherit (self)
      buildHaskellPackages
      ghc
      ghcWithHoogle
      ghcWithPackages
      ;
    inherit (self.buildHaskellPackages) jailbreak-cabal;
    hscolour = overrideCabal (drv: {
      isLibrary = false;
      doHaddock = false;
      hyperlinkSource = false; # Avoid depending on hscolour for this build.
      postFixup = "rm -rf $out/lib $out/share $out/nix-support";
    }) self.buildHaskellPackages.hscolour;
    cpphs =
      overrideCabal
        (drv: {
          isLibrary = false;
          postFixup = "rm -rf $out/lib $out/share $out/nix-support";
        })
        (
          self.cpphs.overrideScope (
            self: super: {
              mkDerivation =
                drv:
                super.mkDerivation (
                  drv
                  // {
                    enableSharedExecutables = false;
                    enableSharedLibraries = false;
                    doHaddock = false;
                    useCpphs = false;
                  }
                );
            }
          )
        );
  };

  mkDerivation = makeOverridable mkDerivationImpl;

  # manualArgs are the arguments that were explicitly passed to `callPackage`, like:
  #
  # callPackage foo { bar = null; };
  #
  # here `bar` is a manual argument.
  callPackageWithScope =
    scope: fn: manualArgs:
    let
      # this code is copied from callPackage in lib/customisation.nix
      #
      # we cannot use `callPackage` here because we want to call `makeOverridable`
      # on `drvScope` (we cannot add `overrideScope` after calling `callPackage` because then it is
      # lost on `.override`) but determine the auto-args based on `drv` (the problem here
      # is that nix has no way to "passthrough" args while preserving the reflection
      # info that callPackage uses to determine the arguments).
      drv = if lib.isFunction fn then fn else import fn;
      drvFunctionArgs = lib.functionArgs drv;
      auto = builtins.intersectAttrs drvFunctionArgs scope;

      # Converts a returned function to a functor attribute set if necessary
      ensureAttrs = v: if builtins.isFunction v then { __functor = _: v; } else v;

      # this wraps the `drv` function to add `scope` and `overrideScope` to the result.
      # it's a functor, so that we can pass through `functionArgs`
      drvScope = {
        __functor =
          _: allArgs:
          ensureAttrs (drv allArgs)
          // {
            inherit scope;
            overrideScope =
              f:
              let
                newScope = mkScope (fix' (extends f scope.__unfix__));
              in
              # note that we have to be careful here: `allArgs` includes the auto-arguments that
              # weren't manually specified. If we would just pass `allArgs` to the recursive call here,
              # then we wouldn't look up any packages in the scope in the next interation, because it
              # appears as if all arguments were already manually passed, so the scope change would do
              # nothing.
              callPackageWithScope newScope drv manualArgs;
          };
        # `drvScope` accepts the same arguments as `drv`
        __functionArgs = drvFunctionArgs;
      };
    in
    lib.makeOverridable drvScope (auto // manualArgs);

  mkScope =
    scope:
    let
      ps = pkgs.__splicedPackages;
      scopeSpliced =
        pkgs.splicePackages {
          pkgsBuildBuild = scope.buildHaskellPackages.buildHaskellPackages;
          pkgsBuildHost = scope.buildHaskellPackages;
          pkgsBuildTarget = { };
          pkgsHostHost = { };
          pkgsHostTarget = scope;
          pkgsTargetTarget = { };
        }
        // {
          # Don't splice these
          inherit (scope) ghc buildHaskellPackages;
        };
    in
    ps // ps.xorg // ps.gnome2 // { inherit stdenv; } // scopeSpliced;
  defaultScope = mkScope self;
  callPackage = drv: args: callPackageWithScope defaultScope drv args;

  # Use cabal2nix to create a default.nix for the package sources found at 'src'.
  haskellSrc2nix =
    {
      name,
      src,
      sha256 ? null,
      extraCabal2nixOptions ? "",
    }:
    let
      sha256Arg = if sha256 == null then "--sha256=" else ''--sha256="${sha256}"'';
    in
    buildPackages.runCommand "cabal2nix-${name}"
      {
        nativeBuildInputs = [ buildPackages.cabal2nix-unwrapped ];
        preferLocalBuild = true;
        allowSubstitutes = false;
        LANG = "en_US.UTF-8";
        LOCALE_ARCHIVE = pkgs.lib.optionalString (
          buildPlatform.libc == "glibc"
        ) "${buildPackages.glibcLocales}/lib/locale/locale-archive";
      }
      ''
        export HOME="$TMP"
        mkdir -p "$out"
        cabal2nix --compiler=${self.ghc.haskellCompilerName} --system=${hostPlatform.config} ${sha256Arg} "${src}" ${extraCabal2nixOptions} > "$out/default.nix"
      '';

  # Given a package name and version, e.g. name = "async", version = "2.2.4",
  # gives its cabal file and hashes (JSON file) as discovered from the
  # all-cabal-hashes value. If that's a directory, it will copy the relevant
  # files to $out; if it's a tarball, it will extract and move them to $out.
  all-cabal-hashes-component =
    name: version:
    buildPackages.runCommand "all-cabal-hashes-component-${name}-${version}" { } ''
      mkdir -p $out
      if [ -d ${all-cabal-hashes} ]
      then
        cp ${all-cabal-hashes}/${name}/${version}/${name}.json $out
        cp ${all-cabal-hashes}/${name}/${version}/${name}.cabal $out
      else
        tar --wildcards -xzvf ${all-cabal-hashes} \*/${name}/${version}/${name}.{json,cabal}
        mv */${name}/${version}/${name}.{json,cabal} $out
      fi
    '';

  hackage2nix =
    name: version:
    let
      component = all-cabal-hashes-component name version;
    in
    self.haskellSrc2nix {
      name = "${name}-${version}";
      sha256 = ''$(sed -e 's/.*"SHA256":"//' -e 's/".*$//' "${component}/${name}.json")'';
      src = "${component}/${name}.cabal";
    };

  # Adds a nix file derived from cabal2nix in the passthru of the derivation it
  # produces. This is useful to debug callHackage / callCabal2nix by looking at
  # the content of the nix file pointed by `cabal2nixDeriver`.
  # However, it does not keep a reference to that file, which may be garbage
  # collected, which may be an annoyance.
  callPackageKeepDeriver =
    src: args:
    overrideCabal (orig: {
      passthru = orig.passthru or { } // {
        # When using callCabal2nix or callHackage, it is often useful
        # to debug a failure by inspecting the Nix expression
        # generated by cabal2nix. This can be accessed via this
        # cabal2nixDeriver field.
        cabal2nixDeriver = src;
      };
    }) (self.callPackage src args);

in
package-set { inherit pkgs lib callPackage; } self
// {

  inherit
    mkDerivation
    callPackage
    haskellSrc2nix
    hackage2nix
    buildHaskellPackages
    ;

  inherit (haskellLib) packageSourceOverrides;

  # callHackage :: Text -> Text -> AttrSet -> HaskellPackage
  #
  # e.g., while overriding a package set:
  #    '... foo = self.callHackage "foo" "1.5.3" {}; ...'
  callHackage = name: version: callPackageKeepDeriver (self.hackage2nix name version);

  # callHackageDirect
  #   :: { pkg :: Text, ver :: Text, sha256 :: Text }
  #   -> AttrSet
  #   -> HaskellPackage
  #
  # This function does not depend on all-cabal-hashes and therefore will work
  # for any version that has been released on hackage as opposed to only
  # versions released before whatever version of all-cabal-hashes you happen
  # to be currently using.
  callHackageDirect =
    {
      pkg,
      ver,
      sha256,
      candidate ? false,
      rev ? {
        revision = null;
        sha256 = null;
      },
    }:
    args:
    let
      pkgver = "${pkg}-${ver}";
      firstRevision = self.callCabal2nix pkg (pkgs.fetchzip {
        url =
          if candidate then
            "mirror://hackage/${pkgver}/candidate/${pkgver}.tar.gz"
          else
            "mirror://hackage/${pkgver}/${pkgver}.tar.gz";
        inherit sha256;
      }) args;
    in
    overrideCabal (orig: {
      revision = rev.revision;
      editedCabalFile = rev.sha256;
    }) firstRevision;

  # Creates a Haskell package from a source package by calling cabal2nix on the source.
  callCabal2nixWithOptions =
    name: src: opts: args:
    let
      extraCabal2nixOptions = if builtins.isString opts then opts else opts.extraCabal2nixOptions or "";
      srcModifier = opts.srcModifier or null;
      defaultFilter = path: type: pkgs.lib.hasSuffix ".cabal" path || baseNameOf path == "package.yaml";
      expr = self.haskellSrc2nix {
        inherit name extraCabal2nixOptions;
        src =
          if srcModifier != null then
            srcModifier src
          else if pkgs.lib.canCleanSource src then
            pkgs.lib.cleanSourceWith {
              inherit src;
              filter = defaultFilter;
            }
          else
            src;
      };
    in
    overrideCabal (orig: {
      inherit src;
    }) (callPackageKeepDeriver expr args);

  callCabal2nix =
    name: src: args:
    self.callCabal2nixWithOptions name src "" args;

  # : { root : Path
  #   , name : Defaulted String
  #   , source-overrides : Defaulted (Either Path VersionNumber)
  #   , overrides : Defaulted (HaskellPackageOverrideSet)
  #   , modifier : Defaulted
  #   , returnShellEnv : Defaulted
  #   , withHoogle : Defaulted
  #   , cabal2nixOptions : Defaulted
  #   } -> NixShellAwareDerivation
  #
  # Given a path to a haskell package directory, an optional package name
  # which defaults to the base name of the path, an optional set of source
  # overrides as appropriate for the 'packageSourceOverrides' function, an
  # optional set of arbitrary overrides, and an optional haskell package
  # modifier, return a derivation appropriate for nix-build or nix-shell to
  # build that package.
  #
  # If 'returnShellEnv' is true this returns a derivation which will give you
  # an environment suitable for developing the listed packages with an
  # incremental tool like cabal-install.
  #
  # If 'withHoogle' is true (the default if a shell environment is requested)
  # then 'ghcWithHoogle' is used to generate the derivation (instead of
  # 'ghcWithPackages'), see the documentation there for more information.
  #
  # 'cabal2nixOptions' can contain extra command line arguments to pass to
  # 'cabal2nix' when generating the package derivation, for example setting
  # a cabal flag with '--flag=myflag'.
  developPackage =
    {
      root,
      name ? lib.optionalString (builtins.typeOf root == "path") (builtins.baseNameOf root),
      source-overrides ? { },
      overrides ? self: super: { },
      modifier ? drv: drv,
      returnShellEnv ? pkgs.lib.inNixShell,
      withHoogle ? returnShellEnv,
      cabal2nixOptions ? "",
    }:
    let
      drv =
        (extensible-self.extend (
          pkgs.lib.composeExtensions (self.packageSourceOverrides source-overrides) overrides
        )).callCabal2nixWithOptions
          name
          root
          cabal2nixOptions
          { };
    in
    if returnShellEnv then (modifier drv).envFunc { inherit withHoogle; } else modifier drv;

  # This can be used to easily create a derivation containing GHC and the specified set of Haskell packages.
  #
  # Example:
  #   $ nix-shell -p 'haskellPackages.ghcWithPackages (hpkgs: [ hpkgs.mtl hpkgs.lens ])'
  #   $ ghci    # in the nix-shell
  #   Prelude > import Control.Lens
  #
  # GHC is setup with a package database with all the specified Haskell packages.
  #
  # ghcWithPackages :: (HaskellPkgSet -> [ HaskellPkg ]) -> Derivation
  ghcWithPackages = buildHaskellPackages.callPackage ./with-packages-wrapper.nix {
    haskellPackages = self;
    inherit (self) hoogleWithPackages;
  };

  # Put 'hoogle' into the derivation's PATH with a database containing all
  # the package's dependencies; run 'hoogle server --local' in a shell to
  # host a search engine for the dependencies.
  #
  # Example usage:
  #  $ nix-shell -p 'haskellPackages.hoogleWithPackages (p: [ p.mtl p.lens ])'
  #  [nix-shell] $ hoogle server
  #
  # hoogleWithPackages :: (HaskellPkgSet -> [ HaskellPkg ]) -> Derivation
  #
  # To reload the Hoogle server automatically on .cabal file changes try
  # this:
  # echo *.cabal | entr -r -- nix-shell --run 'hoogle server --local'
  hoogleWithPackages = self.callPackage ./hoogle.nix {
    haskellPackages = self;
  };
  hoogleLocal =
    {
      packages ? [ ],
    }:
    lib.warn "hoogleLocal is deprecated, use hoogleWithPackages instead" (
      self.hoogleWithPackages (_: packages)
    );
  # This is like a combination of ghcWithPackages and hoogleWithPackages.
  # It provides a derivation containing both GHC and Hoogle with an index of
  # the given Haskell package database.
  #
  # Example:
  #   $ nix-shell -p 'haskellPackages.ghcWithHoogle (hpkgs: [ hpkgs.conduit hpkgs.lens ])'
  #
  # ghcWithHoogle :: (HaskellPkgSet -> [ HaskellPkg ]) -> Derivation
  ghcWithHoogle = self.ghcWithPackages.override {
    withHoogle = true;
  };

  # Returns a derivation whose environment contains a GHC with only
  # the dependencies of packages listed in `packages`, not the
  # packages themselves. Using nix-shell on this derivation will
  # give you an environment suitable for developing the listed
  # packages with an incremental tool like cabal-install.
  #
  # In addition to the "packages" arg and "withHoogle" arg, anything that
  # can be passed into stdenv.mkDerivation can be included in the input attrset
  #
  #     # default.nix
  #     with import <nixpkgs> {};
  #     haskellPackages.extend (haskell.lib.compose.packageSourceOverrides {
  #       frontend = ./frontend;
  #       backend = ./backend;
  #       common = ./common;
  #     })
  #
  #     # shell.nix
  #     let pkgs = import <nixpkgs> {} in
  #     (import ./.).shellFor {
  #       packages = p: [p.frontend p.backend p.common];
  #       withHoogle = true;
  #       buildInputs = [ pkgs.python pkgs.cabal-install ];
  #     }
  #
  #     -- cabal.project
  #     packages:
  #       frontend/
  #       backend/
  #       common/
  #
  #     bash$ nix-shell --run "cabal new-build all"
  #     bash$ nix-shell --run "python"
  shellFor =
    {
      # Packages to create this development shell for.  These are usually
      # your local packages.
      packages,
      # Whether or not to generate a Hoogle database for all the
      # dependencies.
      withHoogle ? false,
      # Whether or not to include benchmark dependencies of your local
      # packages.  You should set this to true if you have benchmarks defined
      # in your local packages that you want to be able to run with cabal benchmark
      doBenchmark ? false,
      # An optional function that can modify the generic builder arguments
      # for the fake package that shellFor uses to construct its environment.
      #
      # Example:
      #   let
      #     # elided...
      #     haskellPkgs = pkgs.haskell.packages.ghc884.override (hpArgs: {
      #       overrides = pkgs.lib.composeExtensions (hpArgs.overrides or (_: _: { })) (
      #         _hfinal: hprev: {
      #           mkDerivation = args: hprev.mkDerivation ({
      #             doCheck = false;
      #             doBenchmark = false;
      #             doHoogle = true;
      #             doHaddock = true;
      #             enableLibraryProfiling = false;
      #             enableExecutableProfiling = false;
      #           } // args);
      #         }
      #       );
      #     });
      #   in
      #   haskellPkgs.shellFor {
      #     packages = p: [ p.foo ];
      #     genericBuilderArgsModifier = args: args // { doCheck = true; doBenchmark = true };
      #   }
      #
      # This will disable tests and benchmarks for everything in "haskellPkgs"
      # (which will invalidate the binary cache), and then re-enable them
      # for the "shellFor" environment (ensuring that any test/benchmark
      # dependencies for "foo" will be available within the nix-shell).
      genericBuilderArgsModifier ? (args: args),

      # Extra dependencies, in the form of cabal2nix build attributes.
      #
      # An example use case is when you have Haskell scripts that use
      # libraries that don't occur in your packages' dependencies.
      #
      # Example:
      #
      #   extraDependencies = p: {
      #     libraryHaskellDepends = [ p.releaser ];
      #   };
      extraDependencies ? p: { },
      ...
    }@args:
    let
      # A list of the packages we want to build a development shell for.
      # This is a list of Haskell package derivations.
      selected = packages self;

      # This is a list of attribute sets, where each attribute set
      # corresponds to the build inputs of one of the packages input to shellFor.
      #
      # Each attribute has keys like buildDepends, executableHaskellDepends,
      # testPkgconfigDepends, etc.  The values for the keys of the attribute
      # set are lists of dependencies.
      #
      # Example:
      #   cabalDepsForSelected
      #   => [
      #        # This may be the attribute set corresponding to the `backend`
      #        # package in the example above.
      #        { buildDepends = [ gcc ... ];
      #          libraryHaskellDepends = [ lens conduit ... ];
      #          ...
      #        }
      #        # This may be the attribute set corresponding to the `common`
      #        # package in the example above.
      #        { testHaskellDepends = [ tasty hspec ... ];
      #          libraryHaskellDepends = [ lens aeson ];
      #          benchmarkHaskellDepends = [ criterion ... ];
      #          ...
      #        }
      #        ...
      #      ]
      cabalDepsForSelected = map (p: p.getCabalDeps) selected;

      # A predicate that takes a derivation as input, and tests whether it is
      # the same as any of the `selected` packages.
      #
      # Returns true if the input derivation is not in the list of `selected`
      # packages.
      #
      # isNotSelected :: Derivation -> Bool
      #
      # Example:
      #
      #   isNotSelected common [ frontend backend common ]
      #   => false
      #
      #   isNotSelected lens [ frontend backend common ]
      #   => true
      isNotSelected = input: pkgs.lib.all (p: input.outPath or null != p.outPath) selected;

      # A function that takes a list of list of derivations, filters out all
      # the `selected` packages from each list, and concats the results.
      #
      #   zipperCombinedPkgs :: [[Derivation]] -> [Derivation]
      #
      # Example:
      #   zipperCombinedPkgs [ [ lens conduit ] [ aeson frontend ] ]
      #   => [ lens conduit aeson ]
      #
      # Note: The reason this isn't just the function `pkgs.lib.concat` is
      # that we need to be careful to remove dependencies that are in the
      # `selected` packages.
      #
      # For instance, in the above example, if `common` is a dependency of
      # `backend`, then zipperCombinedPkgs needs to be careful to filter out
      # `common`, because cabal will end up ignoring that built version,
      # assuming new-style commands.
      zipperCombinedPkgs = vals: pkgs.lib.concatMap (drvList: pkgs.lib.filter isNotSelected drvList) vals;

      # Zip `cabalDepsForSelected` into a single attribute list, combining
      # the derivations in all the individual attributes.
      #
      # Example:
      #   packageInputs
      #   => # Assuming the value of cabalDepsForSelected is the same as
      #      # the example in cabalDepsForSelected:
      #      { buildDepends = [ gcc ... ];
      #        libraryHaskellDepends = [ lens conduit aeson ... ];
      #        testHaskellDepends = [ tasty hspec ... ];
      #        benchmarkHaskellDepends = [ criterion ... ];
      #        ...
      #      }
      #
      # See the Note in `zipperCombinedPkgs` for what gets filtered out from
      # each of these dependency lists.
      packageInputs = pkgs.lib.zipAttrsWith (_name: zipperCombinedPkgs) (
        cabalDepsForSelected ++ [ (extraDependencies self) ]
      );

      # A attribute set to pass to `haskellPackages.mkDerivation`.
      #
      # The important thing to note here is that all the fields from
      # packageInputs are set correctly.
      genericBuilderArgs = {
        pname = if pkgs.lib.length selected == 1 then (pkgs.lib.head selected).name else "packages";
        version = "0";
        license = null;
      }
      // packageInputs
      // pkgs.lib.optionalAttrs doBenchmark {
        # `doBenchmark` needs to explicitly be set here because haskellPackages.mkDerivation defaults it to `false`.  If the user wants benchmark dependencies included in their development shell, it has to be explicitly enabled here.
        doBenchmark = true;
      };

      # This is a pseudo Haskell package derivation that contains all the
      # dependencies for the packages in `selected`.
      #
      # This is a derivation created with `haskellPackages.mkDerivation`.
      #
      # pkgWithCombinedDeps :: HaskellDerivation
      pkgWithCombinedDeps = self.mkDerivation (genericBuilderArgsModifier genericBuilderArgs);

      # The derivation returned from `envFunc` for `pkgWithCombinedDeps`.
      #
      # This is a derivation that can be run with `nix-shell`.  It provides a
      # GHC with a package database with all the dependencies of our
      # `selected` packages.
      #
      # This is a derivation created with `stdenv.mkDerivation` (not
      # `haskellPackages.mkDerivation`).
      #
      # pkgWithCombinedDepsDevDrv :: Derivation
      pkgWithCombinedDepsDevDrv = pkgWithCombinedDeps.envFunc { inherit withHoogle; };

      mkDerivationArgs = builtins.removeAttrs args [
        "genericBuilderArgsModifier"
        "packages"
        "withHoogle"
        "doBenchmark"
        "extraDependencies"
      ];

    in
    pkgWithCombinedDepsDevDrv.overrideAttrs (
      old:
      mkDerivationArgs
      // {
        nativeBuildInputs = old.nativeBuildInputs ++ mkDerivationArgs.nativeBuildInputs or [ ];
        buildInputs = old.buildInputs ++ mkDerivationArgs.buildInputs or [ ];
      }
    );

  ghc = ghc // {
    withPackages = self.ghcWithPackages;
    withHoogle = self.ghcWithHoogle;
  };

  /*
    Run `cabal sdist` on a source.

    Unlike `haskell.lib.sdistTarball`, this does not require any dependencies
    to be present, as it uses `cabal-install` instead of building `Setup.hs`.
    This makes `cabalSdist` faster than `sdistTarball`.
  */
  cabalSdist =
    {
      src,
      name ? if src ? name then "${src.name}-sdist.tar.gz" else "source.tar.gz",
    }:
    pkgs.runCommandLocal name
      {
        inherit src;
        nativeBuildInputs = [
          buildHaskellPackages.cabal-install

          # TODO after https://github.com/haskell/cabal/issues/8352
          #      remove ghc
          self.ghc
        ];
        dontUnpack = false;
      }
      ''
        unpackPhase
        cd "''${sourceRoot:-.}"
        patchPhase
        mkdir out
        HOME=$PWD cabal sdist --output-directory out
        mv out/*.tar.gz $out
      '';

  /*
    Like `haskell.lib.buildFromSdist`, but using `cabal sdist` instead of
    building `./Setup`.

    Unlike `haskell.lib.buildFromSdist`, this does not require any dependencies
    to be present. This makes `buildFromCabalSdist` faster than `haskell.lib.buildFromSdist`.
  */
  buildFromCabalSdist =
    pkg:
    haskellLib.overrideSrc {
      src = self.cabalSdist { inherit (pkg) src; };
      version = pkg.version;
    } pkg;

  /*
    Modify a Haskell package to add shell completion scripts for the
    given executables produced by it. These completion scripts will be
    picked up automatically if the resulting derivation is installed,
    e.g. by `nix-env -i`.

    This depends on the `--*-completion` flag `optparse-applicative` provides
    automatically. Since we need to invoke installed executables, completions
    are not generated if we are cross-compiling.

     commands: names of the executables built by the derivation
          pkg: Haskell package that builds the executables

    Example:
      generateOptparseApplicativeCompletions [ "exec1" "exec2" ] pkg

     Type: [str] -> drv -> drv
  */
  generateOptparseApplicativeCompletions = self.callPackage (
    { stdenv }:

    commands: pkg:

    if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
      lib.foldr haskellLib.__generateOptparseApplicativeCompletion pkg commands
    else
      pkg
  ) { };

  /*
    Modify given Haskell package to force GHC to employ the LLVM
    codegen backend when compiling. Useful when working around bugs
    in a native codegen backend GHC defaults to.

    Example:
      forceLlvmCodegenBackend tls

    Type: drv -> drv
  */
  forceLlvmCodegenBackend = overrideCabal (drv: {
    configureFlags = drv.configureFlags or [ ] ++ [ "--ghc-option=-fllvm" ];
    buildTools =
      drv.buildTools or [ ]
      ++ [ self.ghc.llvmPackages.llvm ]
      # GHC >= 9.10 needs LLVM specific assembler, i.e. clang
      # On Darwin clang is always required
      ++ lib.optionals (lib.versionAtLeast self.ghc.version "9.10" || stdenv.hostPlatform.isDarwin) [
        self.ghc.llvmPackages.clang
      ];
  });
}
