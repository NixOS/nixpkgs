{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytest-mockito
, pytestCheckHook
, robotframework
}:

buildPythonPackage rec {
  pname = "robotframework-pythonlibcore";
  version = "4.1.0";

  disabled = pythonOlder "3.7";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "robotframework";
    repo = "PythonLibCore";
    rev = "v${version}";
    hash = "sha256-BgnllONYJjfeKIN8BLfMw1iZrVewtXB1KN8b9KjdtK0=";
  };

  nativeCheckInputs = [
    pytest-mockito
    pytestCheckHook
    robotframework
  ];

  preCheck = ''
    export PYTHONPATH="atest:utest/helpers:$PYTHONPATH"
  '';

  pythonImportsCheck = [ "robotlibcore" ];

  meta = {
    changelog = "https://github.com/robotframework/PythonLibCore/blob/${src.rev}/docs/PythonLibCore-${version}.rst";
    description = "Tools to ease creating larger test libraries for Robot Framework using Python";
    homepage = "https://github.com/robotframework/PythonLibCore";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
