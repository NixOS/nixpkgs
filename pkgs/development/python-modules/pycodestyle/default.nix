{ buildPythonPackage
, pythonOlder
, fetchFromGitHub
, lib
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pycodestyle";
  version = "2.11.0";

  disabled = pythonOlder "3.8";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "pycodestyle";
    rev = "refs/tags/${version}";
    hash = "sha256-a+PkSTMGd5rhzC8YANqXTmpgvjRP6d5julunFdVRh+g=";
  };

  pythonImportsCheck = [
    "pycodestyle"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/PyCQA/pycodestyle/blob/${src.rev}/CHANGES.txt";
    description = "Python style guide checker";
    homepage = "https://pycodestyle.pycqa.org/";
    license = licenses.mit;
    maintainers = with maintainers; [
      kamadorueda
    ];
  };
}
