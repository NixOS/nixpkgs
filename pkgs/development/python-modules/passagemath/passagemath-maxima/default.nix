{
  fetchPypi,
  buildPythonPackage,
  cysignals,
  pexpect,
  passagemath-environment,
  passagemath-ecl,
  passagemath-categories,
  pkgs,
  setuptools,
  cython,
  pkgconfig,
  passagemath-setup,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-maxima";
  version = "10.8.13";

  pyproject = true;
  build-system = [
    setuptools
    passagemath-setup
    pkgconfig
    passagemath-categories
    cython
    cysignals
  ];
  nativeBuildInputs = with pkgs; [
    ecl
  ];
  dependencies = [
    pexpect
    passagemath-ecl
    passagemath-environment
  ];

  src = fetchPypi {
    pname = "passagemath_maxima";
    inherit version;
    hash = "sha256-q7ITA6g3cc4Xo+l68cGIKMN3Xqkcr5gHOFCKGIJSUzg=";
  };
}
