{
  lib,
  fetchPypi,
  buildPythonPackage,
  meson-python,
  cython,
  pkg-config,
  primecount,
  cysignals,

  # Reverse dependency
  sage,
}:

buildPythonPackage rec {
  pname = "primecountpy";
  version = "0.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-iIcGq2XMCJ+5g95GOTYN3ccouqTZh3p62LEW9kVlCzk=";
  };

  build-system = [
    meson-python
    cython
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ primecount ];

  propagatedBuildInputs = [
    cysignals
  ];

  # depends on pytest-cython for "pytest --doctest-cython"
  doCheck = false;

  pythonImportsCheck = [ "primecountpy" ];

  passthru.tests = {
    inherit sage;
  };

  meta = {
    description = "Cython interface for C++ primecount library";
    homepage = "https://github.com/dimpase/primecountpy/";
    teams = [ lib.teams.sage ];
    license = lib.licenses.gpl3Only;
  };
}
