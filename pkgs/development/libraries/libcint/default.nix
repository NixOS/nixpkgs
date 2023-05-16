{ stdenv
, lib
, fetchFromGitHub
, cmake
, blas
  # Check Inputs
, python3
}:

stdenv.mkDerivation rec {
  pname = "libcint";
<<<<<<< HEAD
  version = "5.4.0";
=======
  version = "5.2.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "sunqm";
    repo = "libcint";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-U+ZlD/I7RHtdYNbFhAmeU4qREe45dYJDIAC3Bup2tr0=";
=======
    hash = "sha256-sFdigOlS5fAi2dV4dhcPg3roqFdvpnh580WDqTA6DGg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ blas ];
  cmakeFlags = [
    "-DENABLE_TEST=1"
    "-DQUICK_TEST=1"
    "-DCMAKE_INSTALL_PREFIX=" # ends up double-adding /nix/store/... prefix, this avoids issue
    "-DWITH_RANGE_COULOMB:STRING=1"
    "-DWITH_FORTRAN:STRING=1"
    "-DMIN_EXPCUTOFF:STRING=20"
  ];

  strictDeps = true;

  doCheck = true;
  nativeCheckInputs = [ python3.pkgs.numpy ];

  meta = with lib; {
    description = "General GTO integrals for quantum chemistry";
    longDescription = ''
      libcint is an open source library for analytical Gaussian integrals.
      It provides C/Fortran API to evaluate one-electron / two-electron
      integrals for Cartesian / real-spheric / spinor Gaussian type functions.
    '';
    homepage = "http://wiki.sunqm.net/libcint";
    downloadPage = "https://github.com/sunqm/libcint";
    changelog = "https://github.com/sunqm/libcint/blob/master/ChangeLog";
    license = licenses.bsd2;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
