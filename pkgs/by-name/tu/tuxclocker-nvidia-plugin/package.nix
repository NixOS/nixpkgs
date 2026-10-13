{
  stdenv,
  boost,
  libx11,
  libxext,
  nvidiaPackages,
  openssl,
  tuxclocker-plugins,
}:

stdenv.mkDerivation {
  pname = "tuxclocker-nvidia-plugin";

  inherit (tuxclocker-plugins)
    src
    version
    meta
    nativeBuildInputs
    ;

  buildInputs = [
    boost
    libx11
    libxext
    nvidiaPackages.stable.driver
    nvidiaPackages.stable.settings.libXNVCtrl
    openssl
  ];

  mesonFlags = [
    "-Ddaemon=false"
    "-Dgui=false"
    "-Drequire-nvidia=true"
    "-Dplugins-cpu=false" # provided by tuxclocker-plugins
  ];
}
