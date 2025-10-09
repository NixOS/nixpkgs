{
  lib,
  stdenv,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  icu,
  zlib,
  fontconfig,
  openssl,
  lttng-ust_2_12,
  krb5,
  bash,
  xorg,
  xdg-utils,
  nix-update-script,
}:

buildDotnetModule (finalAttrs: {
  pname = "v2rayn";
  version = "7.14.4";

  src = fetchFromGitHub {
    owner = "2dust";
    repo = "v2rayN";
    tag = finalAttrs.version;
    hash = "sha256-zfQza07GhYFEHwl4w5hqqE9JP/0yY5KIj0zRRNmAECA=";
    fetchSubmodules = true;
  };

  projectFile = "v2rayN/v2rayN.Desktop/v2rayN.Desktop.csproj";

  nugetDeps = ./deps.json;

  postPatch = ''
    chmod +x v2rayN/ServiceLib/Sample/proxy_set_linux_sh
    patchShebangs v2rayN/ServiceLib/Sample/proxy_set_linux_sh
    chmod +x v2rayN/ServiceLib/Sample/kill_as_sudo_linux_sh
    patchShebangs v2rayN/ServiceLib/Sample/kill_as_sudo_linux_sh
    substituteInPlace v2rayN/ServiceLib/Global.cs \
      --replace-fail "/bin/bash" "${bash}/bin/bash"
    substituteInPlace v2rayN/ServiceLib/Manager/CoreAdminManager.cs \
      --replace-fail "/bin/bash" "${bash}/bin/bash"
    substituteInPlace v2rayN/ServiceLib/Handler/AutoStartupHandler.cs \
      --replace-fail "Utils.GetExePath())" '"v2rayN")'
    substituteInPlace v2rayN/ServiceLib/ViewModels/MainWindowViewModel.cs \
      --replace-fail "nautilus" "${xdg-utils}/bin/xdg-open"
    substituteInPlace v2rayN/ServiceLib/Manager/CoreManager.cs \
      --replace-fail 'Environment.GetEnvironmentVariable(Global.LocalAppData) == "1"' "false"
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

  runtimeDeps = with xorg; [
    libX11
    libXrandr
    libXi
    libICE
    libSM
    libXcursor
    libXext
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "v2rayn";
      exec = "v2rayN";
      icon = "v2rayn";
      genericName = "v2rayN";
      desktopName = "v2rayN";
      categories = [ "Network" ];
      terminal = false;
      comment = "A GUI client for Windows and Linux, support Xray core and sing-box-core and others";
    })
  ];

  postInstall = ''
    install -D --mode 0644 v2rayN/v2rayN.Desktop/v2rayN.png $out/share/icons/hicolor/256x256/apps/v2rayn.png
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GUI client support Xray core and sing-box-core and others";
    homepage = "https://github.com/2dust/v2rayN";
    mainProgram = "v2rayN";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = [ ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
