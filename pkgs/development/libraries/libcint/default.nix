{ stdenv
, lib
, fetchFromGitHub
, cmake
, blas
  # Check Inputs
, python2
}:

stdenv.mkDerivation rec {
  pname = "libcint";
  version = "3.0.20";

  src = fetchFromGitHub {
    owner = "sunqm";
    repo = "libcint";
    rev = "v${version}";
    sha256 = "0iqqq568q9sxppr08rvmpyjq0n82pm04x9rxhh3mf20x1ds7ngj5";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ blas ];
  cmakeFlags = [
    "-DENABLE_TEST=1"
    "-DQUICK_TEST=1"
    "-DCMAKE_INSTALL_PREFIX=" # ends up double-adding /nix/store/... prefix, this avoids issue
  ];

  doCheck = true;
  # Test syntax (like print statements) is written in python2. Fixed when #33 merged: https://github.com/sunqm/libcint/pull/33
  checkInputs = [ python2.pkgs.numpy ];

  meta = with lib; {
    description = "General GTO integrals for quantum chemistry";
    longDescription = ''
      libcint is an open source library for analytical Gaussian integrals.
      It provides C/Fortran API to evaluate one-electron / two-electron
      integrals for Cartesian / real-spheric / spinor Gaussian type functions.
    '';
    homepage = "http://wiki.sunqm.net/libcint";
    downloadPage = "https://github.com/sunqm/libcint";
    license = licenses.bsd2;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
