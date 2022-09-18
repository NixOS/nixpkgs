{ lib
, fetchFromGitHub
, buildPythonPackage
, six
, flask
, pytest
, importlib-metadata
, distlib
, pytestCheckHook
, requests
}:

buildPythonPackage rec {
  pname = "pytest-pypi";
  version = "2022.7.24";

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "pipenv";
    rev = "v${version}";
    sha256 = "sha256-vxJ6AcBGM2+s97h8fbYHuQ4EesdZdDcrKgGljIuUG2A=";
  };

  sourceRoot = "source/tests/pytest-pypi";

  propagatedBuildInputs = [
    flask
    pytest
    importlib-metadata
    six
  ];

  checkInputs = [
    distlib
    requests
  ];

  # Doesn't include any tests
  doCheck = false;

  pythonImportsCheck = [ "pytest_pypi" ];

  meta = with lib; {
    description = "Easily test your HTTP library against a local copy of pypi";
    homepage = "https://github.com/pypa/pipenv/tests/pytest-pypi";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
