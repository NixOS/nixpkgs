{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, pytest-mockito
, pytestCheckHook
, robotframework
, typing-extensions
}:

buildPythonPackage rec {
  pname = "robotframework-pythonlibcore";
  version = "4.3.0";

  disabled = pythonOlder "3.8";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "robotframework";
    repo = "PythonLibCore";
    rev = "refs/tags/v${version}";
    hash = "sha256-5ayOQyOhCg4nLpAyH/eQ6NYEApix0wsL2nhJzEXKJRo=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytest-mockito
    pytestCheckHook
    robotframework
    typing-extensions
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
