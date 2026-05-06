{
  lib,
  stdenv,
  udev,
  ncurses,
  pkg-config,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation {
  pname = "xwiimote";
  version = "2-unstable-2024-02-29";

  src = fetchFromGitHub {
    owner = "xwiimote";
    repo = "xwiimote";
    rev = "4df713d9037d814cc0c64197f69e5c78d55caaf1";
    hash = "sha256-y68bi62H7ErVekcs0RZUXPpW+QJ97sTQP4lajB9PsgU=";
  };

  configureFlags = [ "--with-doxygen=no" ];

  buildInputs = [
    udev
    ncurses
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  postInstallPhase = ''
    mkdir -p "$out/etc/X11/xorg.conf.d/"
    cp "res/50-xorg-fix-xwiimote.conf" "$out/etc/X11/xorg.conf.d/50-fix-xwiimote.conf"
  '';

  meta = {
    homepage = "https://xwiimote.github.io/xwiimote/";
    description = "Userspace utilities to control connected Nintendo Wii Remotes";
    mainProgram = "xwiishow";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
