{ stdenv, lib, fetchFromGitHub, cmake, fetchpatch
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

  patches = [
    (fetchpatch{
      name = "reproc-gcc-13-2.patch";
      url = "https://github.com/DaanDeMeyer/reproc/commit/0b23d88894ccedde04537fa23ea55cb2f8365342.patch";
      sha256 = "sha256-QyC0UcKAWCKSvSvyZTLI2eF/TuuqbGGH6cOQrS2DiCE=";
    })
    (fetchpatch{
      name = "reproc-gcc-13-1.patch";
      url = "https://github.com/DaanDeMeyer/reproc/commit/9f399675b821e175f85ac3ee6e3fd2e6056573eb.patch";
      sha256 = "sha256-h/gnDFPWPpUFkys10YXjjEPibgRT1atHSVwbO0kId+U=";
    })
  ];

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
