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
  version = "0-unstable-2025-07-10";

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchhg {
    url = "https://keep.imfreedom.org/xeme/xeme";
    rev = "b33ce037eeb8";
    hash = "sha256-tn5lr6svNSI0bl45ywIiRkMhb739PWU6Tce99XFvcWw=";
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

  doCheck = true;

  meta = {
    description = "High level XMPP parsing library based on GObjects";
    homepage = "https://keep.imfreedom.org/xeme/xeme";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
}
