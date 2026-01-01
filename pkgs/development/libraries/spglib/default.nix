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
<<<<<<< HEAD
  version = "2.7.0"; # N.B: if you change this, please update: pythonPackages.spglib
=======
  version = "2.6.0"; # N.B: if you change this, please update: pythonPackages.spglib
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "spglib";
    repo = "spglib";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-RFvd/j/14YRIcQTpnYPx5edeF3zbHbi90jb32i3ZU/c=";
=======
    hash = "sha256-rmQYFFfpyUhT9pfQZk1fN5tZWTg40wwtszhPhiZpXs4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cmake
    gfortran
    gtest
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ openmp ];

  cmakeFlags = [ "-DSPGLIB_WITH_Fortran=On" ];

  doCheck = true;

<<<<<<< HEAD
  meta = {
    description = "C library for finding and handling crystal symmetries";
    homepage = "https://spglib.github.io/spglib/";
    changelog = "https://github.com/spglib/spglib/raw/v${version}/ChangeLog";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.markuskowa ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    description = "C library for finding and handling crystal symmetries";
    homepage = "https://spglib.github.io/spglib/";
    changelog = "https://github.com/spglib/spglib/raw/v${version}/ChangeLog";
    license = licenses.bsd3;
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
