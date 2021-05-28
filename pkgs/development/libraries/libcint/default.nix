{ stdenv
, lib
, fetchFromGitHub
, cmake
, blas
  # Check Inputs
, python
}:

stdenv.mkDerivation rec {
  pname = "libcint";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "sunqm";
    repo = "libcint";
    rev = "v${version}";
    sha256 = "0j8fkkp3vb1936qy80sc08c327b47qxh0x2aadd1225jjq6xqxmn";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ blas ];
  cmakeFlags = [
    "-DENABLE_TEST=1"
    "-DQUICK_TEST=1"
    "-DCMAKE_INSTALL_PREFIX=" # ends up double-adding /nix/store/... prefix, this avoids issue
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
    changelog = "https://github.com/sunqm/libcint/blob/master/ChangeLog";
    license = licenses.bsd2;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
