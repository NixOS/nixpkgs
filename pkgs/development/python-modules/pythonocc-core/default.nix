{ stdenv, fetchurl, python, opencascade_oce, swig, cmake, x11, mesa_noglu }:

let
   version = "0.16.2";
   sha256 = "b508aa49ab3e8a5ed7b447b118759a270312ee3a96b4b6fc70576f7b43fc26cf";
in
stdenv.mkDerivation rec {
  name = "pythonocc-core-${version}";
  src = fetchurl {
    url = "https://github.com/tpaviot/pythonocc-core/archive/${version}.tar.gz";
    sha256 = sha256;
  };

  preConfigure = ''
    # This needs to be set in preConfigure instead of cmakeFlags in order to
    # access the $out environment variable.
    export cmakeFlagsArray=(
        -DOCE_INCLUDE_PATH=${opencascade_oce}/include/oce
        -DOCE_LIB_PATH=${opencascade_oce}/lib
        -DPYTHONOCC_INSTALL_DIRECTORY=$out/lib/${python.libPrefix}/site-packages/OCC
    )
  '';

  enableParallelBuilding = true;

  buildInputs = [ python opencascade_oce swig cmake x11 mesa_noglu ];

  meta = {
    homepage = https://github.com/tpaviot/pythonocc-core/;
    description = "Python wrapper for the oce C++ library";
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.linux;
  };
}
