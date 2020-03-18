{ stdenv, lib, crystal, shards, git, pkgconfig, which, linkFarm, fetchFromGitHub }:
{
  # Some projects do not include a lock file, so you can pass one
  lockFile ? null
  # Generate shards.nix with `nix-shell -p crystal2nix --run crystal2nix` in the projects root
, shardsFile ? null
  # Specify binaries to build in the form { foo.src = "src/foo.cr"; }
  # The default `crystal build` options can be overridden with { foo.options = [ "--no-debug" ]; }
, crystalBinaries ? {}
, ...
}@args:
let
  mkDerivationArgs = builtins.removeAttrs args [ "shardsFile" "crystalBinaries" ];

  crystalLib = linkFarm "crystal-lib" (
    lib.mapAttrsToList (
      name: value: {
        inherit name;
        path = fetchFromGitHub value;
      }
    ) (import shardsFile)
  );

  # we previously had --no-debug here but that is not recommended by upstream
  defaultOptions = [ "--release" "--progress" "--verbose" ];

  buildDirectly = shardsFile == null || crystalBinaries != {};
in
stdenv.mkDerivation (
  mkDerivationArgs // {

    configurePhase = args.configurePhase or ''
      runHook preConfigure

      ${lib.optionalString (lockFile != null) "ln -s ${lockFile} ./shard.lock"}
      ${lib.optionalString (shardsFile != null) "ln -s ${crystalLib} lib"}

      runHook postConfigure
    '';

    CRFLAGS = lib.concatStringsSep " " defaultOptions;

    buildInputs = args.buildInputs or [] ++ [ crystal shards ];

    nativeBuildInputs = args.nativeBuildInputs or [] ++ [ git pkgconfig which ];

    buildPhase = args.buildPhase or (
      ''
        runHook preBuild

        if [ -e Makefile ]; then
          echo " ** building with make"

          make ''${buildTargets:-build} $buildFlags
        else
      '' + (
        if buildDirectly then ''
          echo " ** building with crystal"

          ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList (
            bin: attrs: ''
              crystal ${lib.escapeShellArgs (
              [
                "build"
                "-o"
                bin
                (attrs.src or (throw "No source file for crystal binary ${bin} provided"))
              ] ++ attrs.options or defaultOptions
            )}
            ''
          ) crystalBinaries
        )}
        '' else ''
          echo " ** building with shards"
          shards build --local --production ${lib.concatStringsSep " " defaultOptions}
        ''
      ) + ''
        fi

        runHook postBuild
      ''
    );

    installPhase = args.installPhase or (
      ''
        runHook preInstall

        if [ -e Makefile ]; then
          make ''${installTargets:-install} $installFlags
        else
      '' + (
        if buildDirectly then
          lib.concatMapStringsSep "\n" (
            bin: ''
              install -Dm555 ${lib.escapeShellArgs [ bin "${placeholder "out"}/bin/${bin}" ]}
            ''
          ) (lib.attrNames crystalBinaries)
        else ''
          shards install
        ''
      ) + ''
        fi

        runHook postInstall
      ''
    );

    meta = args.meta or {} // {
      platforms = args.meta.platforms or crystal.meta.platforms;
    };
  }
)
