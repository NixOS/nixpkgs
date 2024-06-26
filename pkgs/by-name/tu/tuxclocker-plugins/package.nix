{
  lib,
  stdenv,
  boost,
  cmake,
  gettext,
  libdrm,
  meson,
  ninja,
  openssl,
  pkg-config,
  python3,
  tuxclocker,
}:

stdenv.mkDerivation {
  inherit (tuxclocker)
    src
    version
    meta
    BOOST_INCLUDEDIR
    BOOST_LIBRARYDIR
    ;

  pname = "tuxclocker-plugins";

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    (python3.withPackages (p: [ p.hwdata ]))
  ];

  buildInputs = [
    boost
    libdrm
    openssl
  ];

  mesonFlags = [
    "-Ddaemon=false"
    "-Dgui=false"
    "-Drequire-amd=true"
    "-Drequire-python-hwdata=true"
  ];
}
