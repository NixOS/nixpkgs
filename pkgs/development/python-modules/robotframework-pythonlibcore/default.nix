{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  robotframework,
  approvaltests,
  pytest-mockito,
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "robotframework-pythonlibcore";
  version = "4.5.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "robotframework";
    repo = "PythonLibCore";
    tag = "v${version}";
    hash = "sha256-tkPESNRO34q5yH5Y2iHMQe/z18QiAvvzhjhMafxxUWI=";
  };

  build-system = [ setuptools ];

  dependencies = [ robotframework ];

  nativeCheckInputs = [
    approvaltests
    pytest-mockito
    pytestCheckHook
    typing-extensions
  ];

  pythonImportsCheck = [ "robotlibcore" ];

  meta = {
    changelog = "https://github.com/robotframework/PythonLibCore/blob/${src.rev}/docs/PythonLibCore-${version}.rst";
    description = "Tools to ease creating larger test libraries for Robot Framework using Python";
    homepage = "https://github.com/robotframework/PythonLibCore";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
