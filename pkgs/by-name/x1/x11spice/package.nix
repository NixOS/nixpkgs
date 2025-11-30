{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  xorg,
  gtk2,
  spice,
  spice-protocol,
}:

stdenv.mkDerivation {
  pname = "x11spice";
  version = "2019-08-20";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "spice";
    repo = "x11spice";
    rev = "51d2a8ba3813469264959bb3ba2fc6fe08097be6";
    sha256 = "0va5ix14vnqch59gq8wvrhw6q0w0n27sy70xx5kvfj2cl0h1xpg8";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    xorg.libxcb
    xorg.xcbutil
    xorg.utilmacros
    gtk2
    spice
    spice-protocol
  ];

  NIX_LDFLAGS = "-lpthread";

  meta = with lib; {
    description = "Enable a running X11 desktop to be available via a Spice server";
    homepage = "https://gitlab.freedesktop.org/spice/x11spice";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
