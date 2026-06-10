{
  lib,
  stdenv,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  ffmpeg,
  mpg123,
  webkitgtk_4_1,
  nix-update-script,
  versionCheckHook,
  autoPatchelfHook,
  makeWrapper,
  gtk3,
  openssl,
  krb5,
  icu,
  zlib,
}:
buildDotnetModule rec {
  pname = "undercut-f1";
  version = "4.0.73";
  src = fetchFromGitHub {
    owner = "JustAman62";
    repo = "undercut-f1";
    tag = "v${version}";
    hash = "sha256-EZnJDkgQK5je/xrw3+hDK3jqzKDaRbSmNPIVIL5F/8I=";
  };

  projectFile = "UndercutF1.Console/UndercutF1.Console.csproj";

  executables = [ "undercutf1" ];

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.sdk_10_0;

  nugetDeps = ./deps.json;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    gtk3
    webkitgtk_4_1
    openssl
    krb5
    icu
    zlib
  ];

  postPatch = ''
      rm -f .config/dotnet-tools.json
      substituteInPlace UndercutF1.Console/UndercutF1.Console.csproj --replace-fail \
        "<EnableCompressionInSingleFile>true</EnableCompressionInSingleFile>" \
        "<EnableCompressionInSingleFile>false</EnableCompressionInSingleFile><DebugType>none</DebugType>
    <DebugSymbols>false</DebugSymbols>"
  '';

  postFixup = ''
    wrapProgram $out/bin/undercutf1 \
      --prefix PATH : ${
        lib.makeBinPath [
          ffmpeg
          mpg123
        ]
      }
  '';

  dotnetBuildFlags = [
    "-p:DebugType=None"
    "-p:IncludeNativeLibrariesForSelfExtract=true"
    "-p:IncludeAllContentForSelfExtract=true"
    "-p:OverridePackageVersion=${version}"
    "-p:PublicRelease=true"
  ];

  dotnetPublishFlags = [
    "-p:PublishTrimmed=false"
    "-p:OverridePackageVersion=${version}"
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  installCheckPhase = ''
    $out/bin/undercutf1 --version | grep -q "${version}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source F1 Live Timing TUI client with replay, driver tracker and team-radio transcription";
    homepage = "https://github.com/JustAman62/undercut-f1";
    changelog = "https://github.com/JustAman62/undercut-f1/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ linuxmobile ];
    mainProgram = "undercutf1";
    platforms = lib.platforms.linux;
  };
}
