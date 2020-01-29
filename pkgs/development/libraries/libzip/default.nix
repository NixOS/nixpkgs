{ stdenv, fetchurl, cmake, perl, zlib }:

stdenv.mkDerivation rec {
  pname = "libzip";
  version = "1.5.2";

  src = fetchurl {
    url = "https://www.nih.at/libzip/${pname}-${version}.tar.gz";
    sha256 = "05ay8cbm882br0ir2cmzrvdq8q5mr1bnf53l4305xzigpd54lsdy";
  };

  # Fix pkgconfig file paths
  postPatch = ''
    sed -i CMakeLists.txt \
      -e 's#\\''${exec_prefix}/''${CMAKE_INSTALL_LIBDIR}#''${CMAKE_INSTALL_FULL_LIBDIR}#' \
      -e 's#\\''${prefix}/''${CMAKE_INSTALL_INCLUDEDIR}#''${CMAKE_INSTALL_FULL_INCLUDEDIR}#'
  '';

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake perl ];
  propagatedBuildInputs = [ zlib ];

  preCheck = ''
    # regress/runtest is a generated file
    patchShebangs regress
  '';

  meta = with stdenv.lib; {
    homepage = https://www.nih.at/libzip;
    description = "A C library for reading, creating and modifying zip archives";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
