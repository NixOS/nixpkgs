{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  SDL2,
  SDL2_image,
  SDL2_ttf,
}:

let
  dotnet = dotnetCorePackages.dotnet_8;
  pname = "yafc-ce";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "shpaass";
    repo = "yafc-ce";
    rev = version;
    hash = "sha256-M3oBHFTLU3DTbxgwtccZq8L92A0kWb9bJs5RrOUQidY=";
  };
in
buildDotnetModule {
  inherit pname version src;

  projectFile = "Yafc/Yafc.csproj";
  nugetDeps = ./deps.nix;
  dotnet-sdk = dotnet.sdk;
  dotnet-runtime = dotnet.runtime;
  executables = [ "Yafc" ];

  runtimeDeps = [
    SDL2
    SDL2_image
    SDL2_ttf
  ];

  meta = {
    homepage = "https://github.com/shpaass/yafc-ce";
    description = "Planner and analyzer for Factorio";
    longDescription = ''
      Yet Another Factorio Calculator or YAFC is a planner and analyzer.
      The main goal of YAFC is to help with heavily modded Factorio games.

      YAFC Community Edition is an updated and actively-maintained version of the original YAFC.
    '';
    platforms = lib.platforms.x86_64;
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ diamond-deluxe ];
    mainProgram = "Yafc";
  };
}
