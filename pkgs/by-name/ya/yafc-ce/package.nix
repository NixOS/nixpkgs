{
  lib,

  # Build
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,

  # Runtime
  SDL2,
  SDL2_image,
  SDL2_ttf,

  # Updates
  nix-update-script,
}:
let
  dotnet = dotnetCorePackages.dotnet_8;
in
buildDotnetModule (finalAttrs: {
  pname = "yafc-ce";
  version = "2.19.0";

  src = fetchFromGitHub {
    owner = "Yafc-CE";
    repo = "yafc-ce";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O4ldYVfOgq+0lZ7xWtBATzx/xlmz3tydC+YX/fvVgY4=";
  };

  projectFile = [
    "Yafc.I18n.Generator/Yafc.I18n.Generator.csproj"
    "Yafc/Yafc.csproj"
  ];
  testProjectFile = [ "Yafc.Model.Tests/Yafc.Model.Tests.csproj" ];
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnet.sdk;
  dotnet-runtime = dotnet.runtime;

  executables = [ "Yafc" ];

  runtimeDeps = [
    SDL2
    SDL2_ttf
    SDL2_image
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Powerful Factorio calculator/analyser that works with mods, Community Edition";
    longDescription = ''
      Yet Another Factorio Calculator or YAFC is a planner and analyzer.
      The main goal of YAFC is to help with heavily modded Factorio games.

      YAFC Community Edition is an updated and actively-maintained version of the original YAFC.
    '';
    homepage = "https://github.com/Yafc-CE/yafc-ce";
    downloadPage = "https://github.com/Yafc-CE/yafc-ce/releases/tag/v${finalAttrs.version}";
    changelog = "https://github.com/Yafc-CE/yafc-ce/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      diamond-deluxe
      TheColorman
    ];
    platforms = with lib.platforms; x86_64 ++ darwin;
    mainProgram = "Yafc";
  };
})
