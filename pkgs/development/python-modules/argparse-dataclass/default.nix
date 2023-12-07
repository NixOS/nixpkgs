{ lib, buildPythonPackage, fetchFromGitHub, pytestCheckHook }:

buildPythonPackage rec {
  pname = "argparse-dataclass";
  version = "1.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mivade";
    repo = "argparse_dataclass";
    rev = version;
    sha256 = "6//XQKUnCH3ZtOL6M/EstMJ537nEmbuGQNqfelTluOs=";
  };

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "argparse_dataclass" ];

  meta = with lib; {
    description = "Declarative CLIs with argparse and dataclasses";
    homepage = "https://github.com/mivade/argparse_dataclass";
    license = licenses.mit;
    maintainers = with maintainers; [ tm-drtina ];
  };
}
