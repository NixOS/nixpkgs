{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  libxcb-util,
  util-macros,
  libxcb,
  gtk3,
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
    hash = "sha256-6N0eIKBMSLdn6R0cr4+wgANsOMybI/xSgQzbTUKPRW0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libxcb
    libxcb-util
    util-macros
    gtk3
    spice
    spice-protocol
  ];

  env.NIX_LDFLAGS = "-lpthread";

  meta = {
    description = "Enable a running X11 desktop to be available via a Spice server";
    homepage = "https://gitlab.freedesktop.org/spice/x11spice";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ rnhmjoj ];
  };
}
