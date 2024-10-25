{
  buildDotnetModule,
  dotnetCorePackages,
  SDL2,
  SDL2_ttf,
  SDL2_image,
  lib,
  fetchFromGitHub,
  stdenv,
  lua,
}:

buildDotnetModule rec {
  pname = "yafc-ce";
  version = "2.0.0";

  dotnet-sdk = dotnetCorePackages.sdk_8_0_3xx;
  dotnet-runtime = dotnetCorePackages.dotnet_8.runtime;
  runtimeDeps = [
    SDL2
    SDL2_ttf
    SDL2_image
  ];

  src = fetchFromGitHub {
    owner = "shpaass";
    repo = "yafc-ce";
    rev = version;
    hash = "sha256-uqr+S0BAeCks+BkAz5pB+c3UhBjsYkmXNuVba6t+a/0=";
  };

  projectFile = [ "Yafc/Yafc.csproj" ];
  testProjectFile = [ "Yafc.Model.Tests/Yafc.Model.Tests.csproj" ];
  nugetDeps = ./deps.nix;

  executables = [ "Yafc" ];

  postInstall = lib.strings.optionalString stdenv.hostPlatform.isAarch64 ''
    install -Dm644 "${lua}/lib/liblua.so.5.2" "$out/lib/yafc-ce/liblua52.so"
  '';

  meta = rec {
    description = "Powerful Factorio calculator/analyser that works with mods, Community Edition";
    homepage = "https://github.com/shpaass/yafc-ce";
    downloadPage = "https://github.com/shpaass/yafc-ce/releases/tag/${version}";
    changelog = downloadPage;
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.TheColorman ];
    platforms = lib.platforms.unix;
    mainProgram = "Yafc";
  };
}
