{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  gfortran,
  gtest,
  openmp,
}:

stdenv.mkDerivation rec {
  pname = "spglib";
  version = "2.7.0"; # N.B: if you change this, please update: pythonPackages.spglib

  src = fetchFromGitHub {
    owner = "spglib";
    repo = "spglib";
    rev = "v${version}";
    hash = "sha256-RFvd/j/14YRIcQTpnYPx5edeF3zbHbi90jb32i3ZU/c=";
  };

  nativeBuildInputs = [
    cmake
    gfortran
    gtest
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ openmp ];

  cmakeFlags = [ "-DSPGLIB_WITH_Fortran=On" ];

  doCheck = true;

  meta = {
    description = "C library for finding and handling crystal symmetries";
    homepage = "https://spglib.github.io/spglib/";
    changelog = "https://github.com/spglib/spglib/raw/v${version}/ChangeLog";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.markuskowa ];
    platforms = lib.platforms.all;
  };
}
