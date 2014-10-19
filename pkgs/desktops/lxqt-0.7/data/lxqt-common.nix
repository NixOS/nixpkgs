{ stdenv
, fetchgit
, cmake
, qt48
, which
}:

stdenv.mkDerivation rec {
  basename = "lxqt-common";
  version = "0.7.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "6ee1eeeb8b5e502b1a114ee0fc5385f7ef9f8431";
    sha256 = "4de5ffaf8261c6072068b562ab5bc9c1fbefbf10c52292d62de97521c1e46f21";
  };

  buildInputs = [ stdenv cmake qt48 which ];

  # 1) Delete the lines which pull in liblxqt, since CMake will try to install into the liblxqt paths.
  # 2) The xsession files should be installed to $out/usr rather than /usr/share
  # 3) Start startlxqt with bash instead of sh, so that the 'which' command is known
  patchPhase = ''
    sed -i '8,10d' CMakeLists.txt
    substituteInPlace "xsession/CMakeLists.txt" --replace /usr/share $out/usr
    #substituteInPlace startlxqt.in --replace '#!/bin/sh' '#!/usr/bin/env bash'
    substituteInPlace startlxqt.in --replace 'if which' "if ${which}/bin/which"
  '';

  # Set the variable which would have been acquired from liblxqt.
  preConfigure = ''
    cmakeFlags="-DLXQT_ETC_XDG_DIR=$out/etc/xdg -DLXQT_SHARE_DIR=$out/share/lxqt"
  '';

  # Patch the cmake installer file.
  postConfigure = ''
    sed -i s@/etc/xdg@$out/etc/xdg@g autostart/cmake_install.cmake
  '';

  meta = {
    homepage = "http://www.lxqt.org";
    description = "Common data file required for running an lxde-qt session";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
