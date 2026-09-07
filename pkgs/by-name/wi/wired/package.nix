{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  dbus,
  pango,
  cairo,
  libxkbcommon,
  libxscrnsaver,
  libxrandr,
  libxi,
  libxcursor,
  libx11,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wired";
  version = "0.10.7";

  src = fetchFromGitHub {
    owner = "Toqozz";
    repo = "wired-notify";
    tag = finalAttrs.version;
    hash = "sha256-tImxEsXDbWczkZwEjR2aGz0FE/UCdzDhPDRGJ80ICpY=";
  };

  cargoHash = "sha256-oEyyVhA0G17GMrJQ6z/rJgopSolute/qrcC1Qpg+YQU=";

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

  preFixup = ''
    patchelf $out/bin/wired \
      --add-needed libxkbcommon-x11.so \
      --add-rpath ${libxkbcommon}/lib
  '';

  meta = {
    description = "Lightweight notification daemon written in Rust";
    homepage = "https://github.com/Toqozz/wired-notify";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fccapria ];
    badPlatforms = lib.platforms.darwin;
    mainProgram = "wired";
  };
})
