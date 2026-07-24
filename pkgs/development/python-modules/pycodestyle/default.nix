{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  python,
  pytestCheckHook,
  setuptools,
  isPyPy,
}:

buildPythonPackage (finalAttrs: {
  pname = "pycodestyle";
  version = "2.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "pycodestyle";
    tag = finalAttrs.version;
    hash = "sha256-1EEQp/QEulrdU9tTe28NerQ33IWlAiSlicpmNYciW88=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pycodestyle" ];

  nativeCheckInputs = [ pytestCheckHook ];

  # https://github.com/PyCQA/pycodestyle/blob/2.14.0/tox.ini#L16
  postCheck = ''
    ${python.interpreter} -m pycodestyle --statistics pycodestyle.py
  '';

  disabledTests = lib.optionals isPyPy [
    # PyPy reports a SyntaxError instead of ValueError
    "test_check_nullbytes"
  ];

  __structuredAttrs = true;

  meta = {
    changelog = "https://github.com/PyCQA/pycodestyle/blob/${finalAttrs.src.tag}/CHANGES.txt";
    description = "Python style guide checker";
    mainProgram = "pycodestyle";
    homepage = "https://pycodestyle.pycqa.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
})
