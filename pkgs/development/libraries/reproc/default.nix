{ stdenv, lib, fetchFromGitHub, cmake
}:

stdenv.mkDerivation rec {
  pname = "reproc";
  version = "14.2.4";

  src = fetchFromGitHub {
    owner = "DaanDeMeyer";
    repo = "reproc";
    rev = "v${version}";
    sha256 = "sha256-LWzBeKhE7cSiZsK8xWzoTdrOcPiU/zEkmi40WiFytic=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DBUILD_SHARED_LIBS=ON"
    "-DREPROC++=ON"
    "-DREPROC_TEST=ON"
  ];

  # https://github.com/DaanDeMeyer/reproc/issues/81
  postPatch = ''
    substituteInPlace reproc++/reproc++.pc.in \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
    substituteInPlace reproc/reproc.pc.in \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  meta = with lib; {
    homepage = "https://github.com/DaanDeMeyer/reproc";
    description = "A cross-platform (C99/C++11) process library";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
