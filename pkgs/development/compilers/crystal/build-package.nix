{ stdenv, lib, crystal, linkFarm, fetchFromGitHub }:
{ # Generate shards.nix with `nix-shell -p crystal2nix --run crystal2nix` in the projects root
  shardsFile ? null
  # Specify binaries to build in the form { foo.src = "src/foo.cr"; }
  # The default `crystal build` options can be overridden with { foo.options = [ "--no-debug" ]; }
, crystalBinaries ? {}
, ...
}@args:
let
  mkDerivationArgs = builtins.removeAttrs args [ "shardsFile" "crystalBinaries" ];

  crystalLib = linkFarm "crystal-lib" (lib.mapAttrsToList (name: value: {
    inherit name;
    path = fetchFromGitHub value;
  }) (import shardsFile));

  defaultOptions = [ "--release" "--progress" "--no-debug" "--verbose" ];

in stdenv.mkDerivation (mkDerivationArgs // {

  configurePhase = args.configurePhase or ''
    runHook preConfigure
    ${lib.optionalString (shardsFile != null) "ln -s ${crystalLib} lib"}
    runHook postConfigure
  '';

  buildInputs = args.buildInputs or [] ++ [ crystal ];

  buildPhase = args.buildPhase or ''
    runHook preBuild
    ${lib.concatStringsSep "\n" (lib.mapAttrsToList (bin: attrs: ''
      crystal ${lib.escapeShellArgs ([
        "build"
        "-o" bin
        (attrs.src or (throw "No source file for crystal binary ${bin} provided"))
      ] ++ attrs.options or defaultOptions)}
    '') crystalBinaries)}
    runHook postBuild
  '';

  installPhase = args.installPhase or ''
    runHook preInstall
    mkdir -p "$out/bin"
    ${lib.concatMapStringsSep "\n" (bin: ''
      mv ${lib.escapeShellArgs [ bin "${placeholder "out"}/bin/${bin}" ]}
    '') (lib.attrNames crystalBinaries)}
    runHook postInstall
  '';

  meta = args.meta or {} // {
    platforms = args.meta.platforms or crystal.meta.platforms;
  };
})
