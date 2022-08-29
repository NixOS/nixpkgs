{ lib
, antlr4_9-python3-runtime
, buildPythonPackage
, fetchFromGitHub
, jre_minimal
, pydevd
, pytest-mock
, pytestCheckHook
, pythonOlder
, pyyaml
}:

buildPythonPackage rec {
  pname = "omegaconf";
  version = "2.2.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "omry";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-sJUYi0M/6SBSeKVSJoNY7IbVmzRZVTlek8AyL2cOPAM=";
  };

  nativeBuildInputs = [
    jre_minimal
  ];

  propagatedBuildInputs = [
    antlr4_9-python3-runtime
    pyyaml
  ];

  checkInputs = [
    pydevd
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "omegaconf"
  ];

  meta = with lib; {
    description = "Framework for configuring complex applications";
    homepage = "https://github.com/omry/omegaconf";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
