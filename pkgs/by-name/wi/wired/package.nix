{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  dbus,
  pango,
  cairo,
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "wired";
  version = "0.10.6";

  src = fetchFromGitHub {
    owner = "Toqozz";
    repo = "wired-notify";
    rev = "refs/tags/${version}";
    hash = "sha256-AWIV/+vVwDZECZ4lFMSFyuyUKJc/gb72PiBJv6lbhnc=";
  };

  cargoHash = "sha256-gIDMD1jT6Wj5FCgbPURF0aayFBOq2mrZE1GZWQ3iYAA=";

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    dbus
    pango
    cairo
    xorg.libXScrnSaver
    xorg.libXcursor
    xorg.libXrandr
    xorg.libX11
    xorg.libXi
  ];

  postInstall = ''
    mkdir -p $out/usr/lib/systemd/system
    substitute ./wired.service $out/usr/lib/systemd/system/wired.service --replace /usr/bin/wired $out/bin/wired
    install -Dm444 -t $out/etc/wired wired.ron wired_multilayout.ron
  '';

  meta = {
    description = "Lightweight notification daemon written in Rust";
    homepage = "https://github.com/Toqozz/wired-notify";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fccapria ];
    badPlatforms = lib.platforms.darwin;
    mainProgram = "wired";
  };
}
