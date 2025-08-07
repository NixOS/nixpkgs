{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  python,
  pytestCheckHook,
  setuptools,
  isPyPy,
}:

buildPythonPackage rec {
  pname = "pycodestyle";
  version = "2.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "pycodestyle";
    rev = version;
    hash = "sha256-jpF0/sVzRjot8KRdXqvhWpdafzC/Fska6jmG3s2U6Wk=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pycodestyle" ];

  nativeCheckInputs = [ pytestCheckHook ];

  # https://github.com/PyCQA/pycodestyle/blob/2.13.0/tox.ini#L16
  postCheck = ''
    ${python.interpreter} -m pycodestyle --statistics pycodestyle.py
  '';

  disabledTests = lib.optionals isPyPy [
    # PyPy reports a SyntaxError instead of ValueError
    "test_check_nullbytes"
  ];

  meta = with lib; {
    changelog = "https://github.com/PyCQA/pycodestyle/blob/${version}/CHANGES.txt";
    description = "Python style guide checker";
    mainProgram = "pycodestyle";
    homepage = "https://pycodestyle.pycqa.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
