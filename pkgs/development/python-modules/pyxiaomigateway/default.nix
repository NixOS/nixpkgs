{ lib
, buildPythonPackage
, fetchFromGitHub
, cryptography
}:

buildPythonPackage rec {
  pname = "pyxiaomigateway";
  version = "0.13.4";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "PyXiaomiGateway";
    rev = version;
    sha256 = "1xg89sdds04wgil88ihs84cjr3df6lajjbkyb1aymj638ibdyqns";
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
