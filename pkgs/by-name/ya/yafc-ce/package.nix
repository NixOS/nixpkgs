{
  buildDotnetModule,
  stdenv,
  lua,
  lib,
  fetchFromGitHub,
  dotnetCorePackages,
  SDL2,
  SDL2_image,
  SDL2_ttf,
}:

let
  dotnet = dotnetCorePackages.dotnet_8;
  pname = "yafc-ce";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "shpaass";
    repo = "yafc-ce";
    rev = version;
    hash = "sha256-uqr+S0BAeCks+BkAz5pB+c3UhBjsYkmXNuVba6t+a/0=";
  };
in
buildDotnetModule {
  inherit pname version src;

  projectFile = [ "Yafc/Yafc.csproj" ];
  testProjectFile = [ "Yafc.Model.Tests/Yafc.Model.Tests.csproj" ];
  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnet.sdk;
  dotnet-runtime = dotnet.runtime;

  executables = [ "Yafc" ];

  runtimeDeps = [
    SDL2
    SDL2_ttf
    SDL2_image
  ];

  # Arm requires a direct reference to liblua.so.5.2
  postInstall = lib.strings.optionalString stdenv.hostPlatform.isAarch64 ''
    install -Dm644 "${lua}/lib/liblua.so.5.2" "$out/lib/yafc-ce/liblua52.so"
  '';

  meta = {
    description = "Powerful Factorio calculator/analyser that works with mods, Community Edition";
    longDescription = ''
      Yet Another Factorio Calculator or YAFC is a planner and analyzer.
      The main goal of YAFC is to help with heavily modded Factorio games.

      YAFC Community Edition is an updated and actively-maintained version of the original YAFC.
    '';
    homepage = "https://github.com/shpaass/yafc-ce";
    downloadPage = "https://github.com/shpaass/yafc-ce/releases/tag/${version}";
    changelog = downloadPage;
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      diamond-deluxe
      TheColorman
    ];
    platforms = lib.platforms.unix;
    mainProgram = "Yafc";
  };
}
