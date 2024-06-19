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
  version = "2.11.1";

  disabled = pythonOlder "3.6";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "pycodestyle";
    rev = version;
    hash = "sha256-viZwkLopIKJlRgGvyAJndk+3kCxMoVTVT3ni00hNBDA=";
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
