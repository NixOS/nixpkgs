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

  binaryVersion = toString chicken.binaryVersion;
in
lib.extendMkDerivation {
  constructDrv = stdenv.mkDerivation;

  excludeDrvArgNames = [
    "name"
  ];

  extendDrvArgs =
    finalAttrs:
    {
      src,
      chickenInstallFlags ? [ ],
      cscOptions ? [ ],
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
      buildInputs = [ chicken ] ++ args.buildInputs or [ ];

      strictDeps = args.strictDeps or true;

      env = {
        CSC_OPTIONS = lib.concatStringsSep " " cscOptions;
      }
      // args.env or { };

      buildPhase =
        args.buildPhase or ''
          runHook preBuild

          # From CHICKEN 6 on, chicken-install takes a lock in its egg cache even
          # when building an egg from the current directory, and the cache defaults
          # to a location under HOME, which is not writable in the sandbox. The
          # cache itself stays empty: with -cached, chicken-install builds the
          # unpacked egg in place. The install phase runs in the same shell, so it
          # inherits this.
          export CHICKEN_EGG_CACHE="$NIX_BUILD_TOP/chicken-egg-cache"
          mkdir -p "$CHICKEN_EGG_CACHE"

          chicken-install -cached -no-install -host ${lib.escapeShellArgs chickenInstallFlags}

          runHook postBuild
        '';

      installPhase =
        args.installPhase or ''
          runHook preInstall

          repository=$out/lib/chicken/${binaryVersion}
          export CHICKEN_INSTALL_PREFIX=$out
          export CHICKEN_INSTALL_REPOSITORY=$repository
          chicken-install -cached -host ${lib.escapeShellArgs chickenInstallFlags}

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
          runtimeRepositories=$repository:${lib.getLib chicken}/lib/chicken/${binaryVersion}
          IFS=: read -ra repositories <<< "''${CHICKEN_REPOSITORY_PATH-}"
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
              --prefix CHICKEN_INCLUDE_PATH : "$CHICKEN_INCLUDE_PATH:$out/share" \
              --prefix PATH : "$out/bin:${chicken}/bin"
          done

          runHook postInstall
        '';

      dontConfigure = args.dontConfigure or true;

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
