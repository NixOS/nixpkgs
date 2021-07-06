{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "bytecode";
  version = "0.12.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "vstinner";
    repo = pname;
    rev = version;
    sha256 = "sha256-CEfDoJ+JlnxLLVnSxv7bEN891tmwG9zAvtT8GNvp8JU=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bytecode" ];

  meta = with lib; {
    homepage = "https://github.com/vstinner/bytecode";
    description = "Python module to generate and modify bytecode";
    license = licenses.mit;
    maintainers = with maintainers; [ raboof ];
  };
}
