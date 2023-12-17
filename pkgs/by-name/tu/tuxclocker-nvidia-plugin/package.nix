{ lib
, stdenv
, boost
, libX11
, libXext
, linuxPackages
, openssl
, tuxclocker-plugins
}:

stdenv.mkDerivation {
  pname = "tuxclocker-nvidia-plugin";

  inherit (tuxclocker-plugins) src version meta BOOST_INCLUDEDIR BOOST_LIBRARYDIR nativeBuildInputs;

  buildInputs = [
    boost
    libX11
    libXext
    linuxPackages.nvidia_x11
    linuxPackages.nvidia_x11.settings.libXNVCtrl
    openssl
  ];

  # Build doesn't have a way to disable building the CPU plugin, which is already
  # provided by 'tuxclocker-plugins'
  patches = [ ./no-cpu-plugin.patch ];

  mesonFlags = [
    "-Ddaemon=false"
    "-Dgui=false"
    "-Drequire-nvidia=true"
  ];
}
