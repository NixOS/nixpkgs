{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  dbus,
  pango,
  cairo,
  libxscrnsaver,
  libxrandr,
  libxi,
  libxcursor,
  libx11,
}:

rustPlatform.buildRustPackage rec {
  pname = "wired";
  version = "0.10.6";

  src = fetchFromGitHub {
    owner = "Toqozz";
    repo = "wired-notify";
    tag = version;
    hash = "sha256-AWIV/+vVwDZECZ4lFMSFyuyUKJc/gb72PiBJv6lbhnc=";
  };

  cargoHash = "sha256-xE6r8l3d9WAXf4DsGbhEiaeMPs02kXY2dG9dk0/7flQ=";

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    dbus
    pango
    cairo
    libxscrnsaver
    libxcursor
    libxrandr
    libx11
    libxi
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
