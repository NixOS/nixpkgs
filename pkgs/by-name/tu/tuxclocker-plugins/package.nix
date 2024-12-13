{
  stdenv,
  boost,
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
  inherit (tuxclocker) src version meta;

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
