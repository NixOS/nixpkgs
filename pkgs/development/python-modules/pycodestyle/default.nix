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
  version = "2.13.0";

  disabled = pythonOlder "3.6";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "pycodestyle";
    rev = version;
    hash = "sha256-jpF0/sVzRjot8KRdXqvhWpdafzC/Fska6jmG3s2U6Wk=";
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
