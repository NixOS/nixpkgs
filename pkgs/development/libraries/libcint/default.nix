{ stdenv
, lib
, fetchFromGitHub
, cmake
, openblas
  # Check Inputs
, python2
}:

stdenv.mkDerivation rec {
  pname = "libcint";
  version = "3.0.19";

  src = fetchFromGitHub {
    owner = "sunqm";
    repo = "libcint";
    rev = "v${version}";
    sha256 = "0x613f2hiqi2vbhp20fcl7rhxb07f2714lplzd0vkvv07phagip9";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openblas ];
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
