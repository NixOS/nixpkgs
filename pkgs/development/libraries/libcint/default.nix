{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, cmake
, openblas
  # Check Inputs
, python
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
    "-DWITH_F12=1"
    "-DWITH_RANGE_COULOMB=1"
    "-DWITH_COULOMB_ERF=1"
  ];

  patches = [
    (fetchpatch {
      name = "libcint-python3-test-syntax-patch";
      url = "http://patch-diff.githubusercontent.com/raw/sunqm/libcint/pull/33.patch";
      sha256 = "1pg9rz8vffijl3kkk6f4frsivd7m2gp2k44llzkaajav4m5q8q4a";
    })
  ];

  doCheck = true;

  checkInputs = [ python.pkgs.numpy ];

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
