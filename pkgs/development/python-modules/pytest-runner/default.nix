{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-runner";
  version = "6.0.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tNhTYu0ptMNIZ43nl99Djw8FCUl924xkcJbAKm2HtoU=";
  };

  postPatch = ''
    rm pytest.ini
  '';

  nativeBuildInputs = [
    setuptools-scm
    pytest
  ];

  checkPhase = ''
    py.test tests
  '';

  # Fixture not found
  doCheck = false;

  meta = with lib; {
    description = "Invoke py.test as distutils command with dependency resolution";
    homepage = "https://github.com/pytest-dev/pytest-runner";
    license = licenses.mit;
  };
}
