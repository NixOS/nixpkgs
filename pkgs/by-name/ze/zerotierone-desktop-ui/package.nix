{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  meson,
  ninja,
  pkg-config,
  gtk3,
  libappindicator,
}:

let
  pname = "zerotierone-desktop-ui";
  version = "1.8.3-unstable-2024-09-26";

  src = fetchFromGitHub {
    owner = "zerotier";
    repo = "DesktopUI";
    rev = "452eca3270f84ef4ac81c955f4777c8f1a82b988";
    hash = "sha256-1gYF9v7sxCO7+pBRBSCYSRaoHEW3Xvx7nh28TsERZy8=";
  };

  libui = stdenv.mkDerivation {
    pname = "libui-ng";
    inherit version src;

    sourceRoot = "${src.name}/libui-ng";

    nativeBuildInputs = [
      meson
      ninja
      pkg-config
    ];

    buildInputs = [ gtk3 ];

    mesonFlags = [
      "-Dc_args=-Wno-error=implicit-function-declaration"
      "--default-library=static"
    ];
  };

  tray = stdenv.mkDerivation {
    pname = "tray";
    inherit version src;

    sourceRoot = "${src.name}/tray";

    nativeBuildInputs = [ pkg-config ];

    buildInputs = [
      gtk3
      libappindicator
    ];

    installPhase = ''
      mkdir -p $out/lib
      mkdir -p $out/include
      cp libzt_desktop_tray.a $out/lib/
      cp tray.h $out/include/
    '';

    NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";
  };
in
rustPlatform.buildRustPackage rec {
  inherit pname version src;

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      "mac-notification-sys-0.5.0" = "sha256-VIFkZWksV7CxeVAiXWtTdJe1v4keoiQSSnZVv8uZTeo=";
    };
  };

  buildInputs = [
    libui
    tray
    gtk3
    libappindicator
  ];

  buildPhase = ''
    cargo build --release
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/440x440/apps
    mkdir -p $out/share/zerotier
    cp target/release/zerotier_desktop_ui $out/bin/
    cp ZeroTierIcon.png $out/share/icons/hicolor/440x440/apps/zerotier.png
    cp zerotier-ui.desktop $out/share/applications/
    substituteInPlace $out/share/applications/zerotier-ui.desktop \
      --replace "/usr/bin/zerotier_desktop_ui" "$out/bin/zerotier_desktop_ui" \
      --replace "/usr/share/zerotier/ZeroTierIcon.png" "zerotier"
  '';

  meta = {
    homepage = "https://zerotier.com/";
    downloadPage = "https://github.com/zerotier/DesktopUI/releases";
    description = "ZeroTier Desktop UI";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      jbbjarnason
    ];
    badPlatforms = [ "darwin" ];
  };
}
