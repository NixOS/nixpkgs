{
  lib,
  stdenv,
  fetchhg,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  glib,
  gi-docgen,
  birb,
}:

stdenv.mkDerivation {
  pname = "xeme";
  version = "0-unstable-2024-09-21";

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchhg {
    url = "https://keep.imfreedom.org/xeme/xeme";
    rev = "e02f61a4476e";
    hash = "sha256-B/BccRtqVRYNM/y/riIZ5mawSC0zRXFT7b6L5CyOQ8M=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    glib
    gi-docgen
  ];

  buildInputs = [
    glib
    gi-docgen
    birb
  ];

  strictDeps = true;

  meta = {
    description = "High level XMPP parsing library based on GObjects";
    homepage = "https://keep.imfreedom.org/xeme/xeme";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
}
