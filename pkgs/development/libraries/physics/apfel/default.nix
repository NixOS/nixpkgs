{ lib
, stdenv
, fetchFromGitHub
, cmake
, gfortran
, lhapdf
, python3
, swig
, zlib
}:

stdenv.mkDerivation rec {
  pname = "apfel";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "scarrazza";
    repo = "apfel";
    rev = version;
    hash = "sha256-RXzHcLgitIk+6pINqcvpQv7QpDpAuFrOHKqjwZ0K5zI=";
  };

  patches = [
    # https://github.com/scarrazza/apfel/pull/54
    ./cmake.patch
  ];

  nativeBuildInputs = [
    cmake
    swig
  ];
  buildInputs = [
    gfortran
    lhapdf
    python3
    zlib
  ];

  cmakeFlags = [
    "-DAPFEL_DOWNLOAD_PDFS=OFF"
    "-DAPFEL_Python_SITEARCH=autoprefix"
  ];

  doCheck = true;
  nativeCheckInputs = [
    lhapdf.pdf_sets.NNPDF23_nlo_as_0118
    lhapdf.pdf_sets.NNPDF31_nnlo_as_0118
  ];

  env.NIX_CFLAGS_COMPILE = "-DAPFEL_VERSION=${version}";

  meta = with lib; {
    description = "A PDF Evolution Library";
    homepage = "https://apfel.mi.infn.it/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ veprbl ];
    platforms = platforms.unix;
  };
}
