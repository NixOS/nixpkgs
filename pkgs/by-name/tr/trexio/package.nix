{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  gfortran,
  hdf5,
  python3,
  emacs,
  swig,
}:

stdenv.mkDerivation rec {
  pname = "trexio";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "TREX-CoE";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-SE5cylLThpwDWyAcQZgawcdYGc/8iiIwL6EyQ+hOIYY=";
  };

  postPatch = ''
    patchShebangs tools/*
  '';

  nativeBuildInputs = [
    cmake
    gfortran
    emacs
    swig
    python3
  ];

  buildInputs = [
    hdf5
  ];

  outputs = [
    "out"
    "dev"
  ];

  doCheck = true;

  meta = with lib; {
    description = "File format and library for the storage of quantum chemical wave functions";
    homepage = "https://trex-coe.github.io/trexio/";
    downloadPage = "https://github.com/TREX-CoE/trexio";
    license = licenses.bsd3;
    maintainers = [ maintainers.sheepforce ];
  };
}
