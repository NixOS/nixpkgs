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
  imagemagick,
  makeDesktopItem,
  copyDesktopItems,
  bash,
}:
buildDotnetModule rec {
  pname = "v2rayn";
  version = "7.3.2";

  src = fetchFromGitHub {
    owner = "2dust";
    repo = "v2rayN";
    tag = version;
    hash = "sha256-mWfWpleUVbq6Z31oh6QoG0j9eT3d7yF6z7e4lRe6+cM=";
  };

  projectFile = "v2rayN/v2rayN.Desktop/v2rayN.Desktop.csproj";

  nugetDeps = ./deps.nix;

  postPatch = ''
    substituteInPlace v2rayN/AmazTool/UpgradeApp.cs \
      --replace-fail "return AppDomain.CurrentDomain.BaseDirectory;" 'return Path.Combine(Environment.GetEnvironmentVariable("XDG_DATA_HOME") ?? Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.UserProfile), ".local", "share"), "v2rayn");'
    substituteInPlace v2rayN/ServiceLib/Common/Utils.cs \
      --replace-fail "return AppDomain.CurrentDomain.BaseDirectory;" 'return Path.Combine(Environment.GetEnvironmentVariable("XDG_DATA_HOME") ?? Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.UserProfile), ".local", "share"), "v2rayn");'
    substituteInPlace v2rayN/ServiceLib/Common/Utils.cs \
      --replace-fail "/bin/bash" "${bash}/bin/bash"
    substituteInPlace v2rayN/ServiceLib/ServiceLib.csproj \
      --replace-fail "0.16.20" "0.16.14"
  '';

  dotnetInstallFlags = [ "-p:PublishReadyToRun=false" ];

  dotnet-sdk = dotnetCorePackages.sdk_8_0;

  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  executables = [ "v2rayN" ];

  nativeBuildInputs = [
    imagemagick
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

  postBuild =
    let
      selectSystem =
        attrs:
        attrs.${stdenv.hostPlatform.system}
          or (throw "v2rayn: ${stdenv.hostPlatform.system} is not supported");
      arch = selectSystem {
        x86_64-linux = "x64";
        aarch64-linux = "arm64";
      };
    in
    ''
      mv ./v2rayN/v2rayN.Desktop/bin/Release/net8.0/linux-${arch} ./v2rayN/v2rayN.Desktop/bin/Release/v2rayn
      rm -r ./v2rayN/v2rayN.Desktop/bin/Release/net8.0
      mv ./v2rayN/v2rayN.Desktop/bin/Release/v2rayn ./v2rayN/v2rayN.Desktop/bin/Release/net8.0
      ln -s . ./v2rayN/v2rayN.Desktop/bin/Release/net8.0/linux-${arch}
    '';

  desktopItems = [
    (makeDesktopItem {
      name = "v2rayn";
      exec = "v2rayN";
      icon = "v2rayn";
      genericName = "v2rayN";
      desktopName = "v2rayN";
    })
  ];

  postInstall = ''
    mkdir -p $out/share/pixmaps
    magick "v2rayN/v2rayN.Desktop/Assets/v2rayN.ico[11]" $out/share/pixmaps/v2rayn.png
  '';

  meta = {
    description = "GUI client for Windows and Linux, support Xray core and sing-box-core and others";
    homepage = "https://github.com/2dust/v2rayN";
    mainProgram = "v2rayN";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ aucub ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
