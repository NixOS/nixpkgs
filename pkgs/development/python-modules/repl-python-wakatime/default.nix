{
  lib,
  buildPythonPackage,
  fetchPypi,
  ipython,
  keyring,
  ptpython,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-generate,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "repl-python-wakatime";
  version = "0.0.12";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-U5kg4GbfhyHno1DNbF1uOfHOjgCstYdyDgvwEXqnCZg=";
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
