{
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  lib,
  python,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pycodestyle";
  version = "2.12.0";

  disabled = pythonOlder "3.6";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "pycodestyle";
    rev = version;
    hash = "sha256-YN1KOJ8f+VY9vJTWm3aTOOai66dveKOKOpeBkZKkC2A=";
  };

  pythonImportsCheck = [ "pycodestyle" ];

  nativeCheckInputs = [ pytestCheckHook ];

  # https://github.com/PyCQA/pycodestyle/blob/2.11.0/tox.ini#L16
  postCheck = ''
    ${python.interpreter} -m pycodestyle --statistics pycodestyle.py
  '';

  meta = with lib; {
    changelog = "https://github.com/PyCQA/pycodestyle/blob/${version}/CHANGES.txt";
    description = "Python style guide checker";
    mainProgram = "pycodestyle";
    homepage = "https://pycodestyle.pycqa.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
