{
  lib,
  buildPythonPackage,
  pythonOlder,
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
  version = "4.4.1";

  disabled = pythonOlder "3.8";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "robotframework";
    repo = "PythonLibCore";
    rev = "refs/tags/v${version}";
    hash = "sha256-5RUi65+DljCqWoB8vZxc0hyIefEFOWuKluplXrD0SkI=";
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
