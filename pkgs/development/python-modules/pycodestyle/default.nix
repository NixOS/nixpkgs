{
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  lib,
  python,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pycodestyle";
  version = "2.11.1";

  disabled = pythonOlder "3.6";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QboOevyXUt+1PO1UieifgYa+AOWZ5xJmBpW3p1/yZj8=";
  };

  pythonImportsCheck = [ "pycodestyle" ];

  nativCheckInputs = [ pytestCheckHook ];

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
