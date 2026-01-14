{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cryptography,
}:

buildPythonPackage rec {
  pname = "pyxiaomigateway";
  version = "0.14.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "PyXiaomiGateway";
    rev = version;
    hash = "sha256-TAbZvs1RrUy9+l2KpfbBopc3poTy+M+Q3ERQLFYbQis=";
  };

  propagatedBuildInputs = [ cryptography ];

  # Tests are not mocking the gateway completely
  doCheck = false;
  pythonImportsCheck = [ "xiaomi_gateway" ];

  meta = {
    description = "Python library to communicate with the Xiaomi Gateway";
    homepage = "https://github.com/Danielhiversen/PyXiaomiGateway/";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
