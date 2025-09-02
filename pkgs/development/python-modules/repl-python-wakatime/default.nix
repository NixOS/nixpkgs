{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ipython,
  keyring,
  ptpython,
  pytestCheckHook,
  setuptools,
  setuptools-generate,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "repl-python-wakatime";
  version = "0.0.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wakatime";
    repo = "repl-python-wakatime";
    tag = version;
    hash = "sha256-fp59usITk7gsUIhrnH5vj36kU1u2QWyu/bs46RDz+As=";
  };

  build-system = [
    setuptools
    setuptools-scm
    setuptools-generate
  ];

  dependencies = [
    ptpython
    ipython
  ];

  nativeCheckInputs = [
    keyring
    pytestCheckHook
  ];

  pythonImportsCheck = [ "repl_python_wakatime" ];

  meta = with lib; {
    description = "Python REPL plugin for automatic time tracking and metrics generated from your programming activity";
    homepage = "https://github.com/wakatime/repl-python-wakatime";
    changelog = "https://github.com/wakatime/repl-python-wakatime/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ jfvillablanca ];
  };
}
