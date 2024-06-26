{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, libusb1
, systemd
}:

stdenv.mkDerivation rec {
  pname = "libtypec";
  version = "unstable-2024-04-14";

  src = fetchFromGitHub {
    owner = "Rajaram-Regupathy";
    repo = pname;
    rev = "3e1027b1896dc8e6f528168ce0ca494656e4f5bc";
    hash = "sha256-lHKaKp2lmoeXci5hEfhqfPP4pE5jF6eUh1U4zZYZRd4=";
  };

  # patches = [
  #   ./cmake-utils-rpath-install.patch
  # ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libusb1
    systemd
  ];

  # postInstall = ''
  #   cd $NIX_BUILD_TOP/source/utils
  #   cmake CMakeLists.txt
  #   cmake -P cmake_install.cmake
  #   make
  #   ls -al $NIX_BUILD_TOP/source/utils


  #   # # TODO: use ins
  #   # mkdir $out/bin
  #   # cp $NIX_BUILD_TOP/source/utils/lstypec ${placeholder "bin"}/bin/lstypec
  #   # cp $NIX_BUILD_TOP/source/utils/typecstatus ${placeholder "bin"}/bin/typecstatus
  #   # # patchelf --print-rpath "$out/bin/lstypec"
  # '';

  meta = with lib; {
    homepage = "https://github.com/Rajaram-Regupathy/libtypec";
    description = "libtypec is aimed to provide a generic interface abstracting all platform complexity for user space to develop tools for efficient USB-C port management. The library can also enable development of diagnostic and debug tools to debug system issues around USB-C/USB PD topology.";
    platforms = platforms.linux;
    license = licenses.mit; # TODO: or gpl2
    maintainers = with maintainers; [ ];
  };
}
