{
  callPackage,
  lib,
  stdenv,
  __splicedPackages,
  chicken,
  makeWrapper,

  # Release-specific arguments, supplied by the per-release directory.
  overridesFile,
}:

let
  # With the spliced package set, what overrides add to each list of
  # dependencies is built for the platform that list is for.
  overrides = callPackage overridesFile { pkgs = __splicedPackages; };

  # When cross-compiling, the chicken in nativeBuildInputs is a cross chicken.
  # Its chicken-install would build every egg twice: once for the build
  # platform, which the build platform's egg set provides already, and once for
  # the target. -target has it build only the latter.
  isCross = stdenv.hostPlatform != stdenv.buildPlatform;
  binaryVersion = toString chicken.binaryVersion;

  # The chicken that runs where the egg does, which the egg links to and its
  # programs run with. Spliced, chicken alone is the one compiling for the
  # target platform, which is a cross chicken in the build platform's egg set
  # of a cross-compiled one, as that set's target is the host platform.
  hostChicken = chicken.__spliced.hostHost or chicken;
in
lib.extendMkDerivation {
  constructDrv = stdenv.mkDerivation;

  excludeDrvArgNames = [
    "name"
    "buildPlatformEgg"
  ];

  extendDrvArgs =
    finalAttrs:
    {
      src,
      chickenInstallFlags ? [ ],
      cscOptions ? [ ],
      # When cross-compiling, this egg built for the build platform, for
      # compiling what imports it and for eggs which load parts of themselves
      # while being compiled.
      buildPlatformEgg ? null,
      ...
    }@args:

    let
      nameVersionAssertion =
        pred: lib.assertMsg pred "either name or both pname and version must be given";
      pname =
        if args ? pname then
          assert nameVersionAssertion (!args ? name && args ? version);
          args.pname
        else
          assert nameVersionAssertion (args ? name && !args ? version);
          lib.getName args.name;
      version = if args ? version then args.version else lib.getVersion args.name;
      allChickenInstallFlags = chickenInstallFlags ++ lib.optional isCross "-target";
    in
    {
      pname = "chicken-${pname}";
      inherit version;
      # Eggs are found in dev, which propagates out and the eggs they depend on.
      outputs =
        args.outputs or [
          "out"
          "dev"
        ];
      nativeBuildInputs = [
        chicken
        makeWrapper
      ]
      ++ args.nativeBuildInputs or [ ];
      # The runtime the egg is compiled against and links to, which, with
      # strictDeps, the chicken in nativeBuildInputs does not provide when
      # cross-compiling.
      buildInputs = [ hostChicken ] ++ args.buildInputs or [ ];

      strictDeps = args.strictDeps or true;

      env = {
        CSC_OPTIONS = lib.concatStringsSep " " cscOptions;
      }
      // args.env or { };

      buildPhase =
        args.buildPhase or (
          ''
            runHook preBuild

            # From CHICKEN 6 on, chicken-install takes a lock in its egg cache even
            # when building an egg from the current directory, and the cache defaults
            # to a location under HOME, which is not writable in the sandbox. The
            # cache itself stays empty: with -cached, chicken-install builds the
            # unpacked egg in place. The install phase runs in the same shell, so it
            # inherits this.
            export CHICKEN_EGG_CACHE="$NIX_BUILD_TOP/chicken-egg-cache"
            mkdir -p "$CHICKEN_EGG_CACHE"

          ''
          + lib.optionalString (buildPlatformEgg != null) ''
            # Eggs whose modules are needed while compiling others, such as for
            # their macros, rely on those built for the build platform being in
            # the build directory, where the compiler looks first. Those are the
            # ones the egg installs.
            for file in ${buildPlatformEgg}/lib/chicken/${binaryVersion}/*.so; do
              [[ -e "''${file##*/}" ]] || ln -s "$file" .
            done

          ''
          + ''
            chicken-install -cached -no-install ${lib.escapeShellArgs allChickenInstallFlags}

            runHook postBuild
          ''
        );

      installPhase =
        args.installPhase or ''
          runHook preInstall

          repository=$out/lib/chicken/${binaryVersion}
          export CHICKEN_INSTALL_PREFIX=$out
          export CHICKEN_INSTALL_REPOSITORY=$repository
          chicken-install -cached ${lib.escapeShellArgs allChickenInstallFlags}

          # What only the compiler and the egg tools use goes to dev, so that eggs
          # loaded at run time do not bring it along: objects and link files, for
          # linking statically, type and inlining information, and the .egg-info,
          # by which chicken-install finds that the egg is installed.
          devRepository=$dev/lib/chicken/${binaryVersion}
          mkdir -p "$devRepository"
          for file in "$repository"/*.{o,a,link,types,inline,egg-info}; do
            if [[ -e "$file" ]]; then
              mv "$file" "$devRepository/"
            fi
          done

          # Patching the generated .egg-info instead of the original .egg; see the
          # script for why.
          csi -s ${./patch-egg-info.scm} ${lib.escapeShellArg version} "$devRepository" < "$devRepository/${pname}.egg-info" > "${pname}.egg-info.new"
          mv "${pname}.egg-info.new" "$devRepository/${pname}.egg-info"

          # Programs run with the repositories of the eggs they use, which are the
          # ones holding extensions and import libraries, in the out outputs, and
          # that of the runtime, with the core modules, as setting
          # CHICKEN_REPOSITORY_PATH replaces it.
          runtimeRepositories=$repository:${lib.getLib hostChicken}/lib/chicken/${binaryVersion}
          IFS=: read -ra repositories <<< "''${NIX_CHICKEN_TARGET_REPOSITORY_PATH-}"
          for dependency in "''${repositories[@]}"; do
            for library in "$dependency"/*.so; do
              if [[ -e "$library" && ":$runtimeRepositories:" != *":$dependency:"* ]]; then
                runtimeRepositories+=":$dependency"
              fi
              break
            done
          done

          for f in $out/bin/*
          do
            wrapProgram $f \
              --prefix CHICKEN_REPOSITORY_PATH : "$runtimeRepositories" \
              --prefix CHICKEN_INCLUDE_PATH : "$NIX_CHICKEN_TARGET_INCLUDE_PATH:$out/share" \
              --prefix PATH : "$out/bin:${hostChicken}/bin"
          done

          runHook postInstall
        '';

      dontConfigure = args.dontConfigure or true;

      # Custom build scripts of eggs, and the helpers they use to probe for
      # libraries, call the C toolchain and pkg-config by their plain names,
      # which do not exist when cross-compiling. As only code for the target is
      # built, they are made to mean the target's tools.
      ${if isCross then "preBuildPhases" else null} = [ "chickenCrossToolsPhase" ];
      ${if isCross then "chickenCrossToolsPhase" else null} = ''
        mkdir -p "$NIX_BUILD_TOP/chicken-cross-tools"
        for tool in cc:CC gcc:CC c++:CXX g++:CXX ar:AR pkg-config:PKG_CONFIG; do
          name=''${tool%:*}
          var=''${tool#*:}
          if [[ -n "''${!var-}" ]]; then
            ln -s "$(command -v "''${!var}")" "$NIX_BUILD_TOP/chicken-cross-tools/$name"
          fi
        done
        export PATH="$NIX_BUILD_TOP/chicken-cross-tools:$PATH"
      '';

      # Compiling code that imports an egg loads the egg, so the cross chicken
      # needs it built for the build platform. Propagating that build puts it,
      # along with the eggs it depends on, in the nativeBuildInputs of whatever
      # takes this egg as a build input. It is only added once the egg is
      # built, as the egg must not see its own declarations while compiling
      # itself, which propagatedNativeBuildInputs would also give it.
      # buildPlatformEgg is this egg spliced, so only values may look at it;
      # attribute names depending on it would recurse infinitely.
      ${if isCross then "preFixupPhases" else null} = lib.optional (
        buildPlatformEgg != null
      ) "chickenPropagateBuildPlatformEggPhase";
      ${if isCross then "chickenPropagateBuildPlatformEggPhase" else null} =
        lib.optionalString (buildPlatformEgg != null)
          ''
            appendToVar propagatedNativeBuildInputs ${lib.getDev buildPlatformEgg}
          '';

      passthru = {
        eggName = pname;
      }
      // args.passthru or { };

      meta = (args.meta or { }) // {
        inherit (chicken.meta) platforms;
        maintainers = lib.lists.unique ((args.meta.maintainers or [ ]) ++ chicken.meta.maintainers);
      };
    };

  # Overrides are applied to the finished derivation, so that they see and
  # extend its final attributes rather than the arguments.
  transformDrv = drv: drv.overrideAttrs (overrides.${drv.eggName} or lib.id);
}
