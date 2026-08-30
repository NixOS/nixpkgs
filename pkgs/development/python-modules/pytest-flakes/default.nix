{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
  pyflakes,
}:

buildPythonPackage (finalAttrs: {
  # upstream has abandoned project in favor of pytest-flake8
  # retaining package to not break other packages
  pname = "pytest-flakes";
  version = "4.0.5";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-lTE06XIVrjH2h5+9c2jBjUP3Cdwvq1t3d9srsrrDqSQ=";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ pyflakes ];
  nativeCheckInputs = [ pytest ];

  # no longer passes
  doCheck = false;
  pythonImportsCheck = [ "pytest_flakes" ];
  # disable one test case that looks broken
  checkPhase = ''
    py.test test_flakes.py -k 'not test_syntax_error'
  '';

  meta = {
    license = lib.licenses.mit;
    homepage = "https://pypi.org/project/pytest-flakes/";
    description = "Pytest plugin to check source code with pyflakes";
  };
})
