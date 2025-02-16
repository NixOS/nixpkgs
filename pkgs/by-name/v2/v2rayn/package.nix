{
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  icu,
  zlib,
  stdenv,
  lib,
  fontconfig,
  autoPatchelfHook,
  openssl,
  lttng-ust_2_12,
  krb5,
  makeDesktopItem,
  copyDesktopItems,
  bash,
  xorg,
  xdg-utils,
}:
buildDotnetModule rec {
  pname = "v2rayn";
  version = "7.7.1";

  src = fetchFromGitHub {
    owner = "2dust";
    repo = "v2rayN";
    tag = version;
    hash = "sha256-u73LzCaGc3vdRs9sG9fdv1jrDubgZGkkxCnP55Bqdx8=";
  };

  projectFile = "v2rayN/v2rayN.Desktop/v2rayN.Desktop.csproj";

  nugetDeps = ./deps.json;

  postPatch = ''
    substituteInPlace v2rayN/ServiceLib/Common/Utils.cs \
      --replace-fail "/bin/bash" "${bash}/bin/bash"
    substituteInPlace v2rayN/ServiceLib/Handler/AutoStartupHandler.cs \
      --replace-fail "Utils.GetExePath())" '"${placeholder "out"}/bin/v2rayN")'
    substituteInPlace v2rayN/ServiceLib/ViewModels/MainWindowViewModel.cs \
      --replace-fail "nautilus" "${xdg-utils}/bin/xdg-open"
  '';

  dotnetBuildFlags = [ "-p:PublishReadyToRun=false" ];

  dotnet-sdk = dotnetCorePackages.sdk_8_0;

  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  executables = [ "v2rayN" ];

  nativeBuildInputs = [
    copyDesktopItems
    autoPatchelfHook
  ];

  buildInputs = [
    zlib
    fontconfig
    icu
    openssl
    krb5
    lttng-ust_2_12
    (lib.getLib stdenv.cc.cc)
  ];

  runtimeDeps = [
    xorg.libX11
    xorg.libXrandr
    xorg.libXi
    xorg.libICE
    xorg.libSM
    xorg.libXcursor
    xorg.libXext
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "v2rayn";
      exec = "v2rayN";
      icon = "v2rayn";
      genericName = "v2rayN";
      desktopName = "v2rayN";
      categories = [
        "Network"
        "Application"
      ];
      terminal = false;
      comment = "A GUI client for Windows and Linux, support Xray core and sing-box-core and others";
    })
  ];

  postInstall = ''
    install -Dm644 v2rayN/v2rayN.Desktop/v2rayN.png $out/share/pixmaps/v2rayn.png
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "GUI client for Windows and Linux, support Xray core and sing-box-core and others";
    homepage = "https://github.com/2dust/v2rayN";
    mainProgram = "v2rayN";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
