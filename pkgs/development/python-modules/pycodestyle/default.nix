{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  python,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pycodestyle";
  version = "2.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "pycodestyle";
    tag = version;
    hash = "sha256-1EEQp/QEulrdU9tTe28NerQ33IWlAiSlicpmNYciW88=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pycodestyle" ];

  nativeCheckInputs = [ pytestCheckHook ];

  # https://github.com/PyCQA/pycodestyle/blob/2.14.0/tox.ini#L16
  postCheck = ''
    ${python.interpreter} -m pycodestyle --statistics pycodestyle.py
  '';

  meta = {
    changelog = "https://github.com/PyCQA/pycodestyle/blob/${src.tag}/CHANGES.txt";
    description = "Python style guide checker";
    mainProgram = "pycodestyle";
    homepage = "https://pycodestyle.pycqa.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
}
