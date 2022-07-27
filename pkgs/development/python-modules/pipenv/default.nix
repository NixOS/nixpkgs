{ lib
, fetchFromGitHub
, buildPythonPackage
, virtualenv-clone
, certifi
, pytestCheckHook
, requests
, pytest-pypi
}:

buildPythonPackage rec {
  pname = "pipenv";
  version = "2022.7.24";

  src = fetchFromGitHub {
    owner = "pypa";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vxJ6AcBGM2+s97h8fbYHuQ4EesdZdDcrKgGljIuUG2A=";
  };

  propagatedBuildInputs = [
    certifi
    virtualenv-clone
  ];

  checkInputs = [
    pytestCheckHook
    pytest-pypi
    requests
  ];

  pythonImportsCheck = [ "pipenv" ];

  meta = with lib; {
    description = "Python Development Workflow for Humans";
    homepage = "https://github.com/pypa/pipenv";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
