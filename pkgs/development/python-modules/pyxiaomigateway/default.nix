{ lib
, buildPythonPackage
, fetchFromGitHub
, cryptography
}:

buildPythonPackage rec {
  pname = "pyxiaomigateway";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "PyXiaomiGateway";
    rev = version;
    sha256 = "sha256-e/FqqUl90VFDJD6ZFbFqXKH3s2sBaDjSFEvaKJhDlGg=";
  };

  propagatedBuildInputs = [ cryptography ];

  # Tests are not mocking the gateway completely
  doCheck = false;
  pythonImportsCheck = [ "xiaomi_gateway" ];

  meta = with lib; {
    description = "Python library to communicate with the Xiaomi Gateway";
    homepage = "https://github.com/Danielhiversen/PyXiaomiGateway/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
