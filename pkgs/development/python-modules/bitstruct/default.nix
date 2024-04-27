{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "bitstruct";
  version = "8.19.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-11up3e2FwX6IWiCaAOuOJI7kB2IUny8qeTYMqFdGfaw=";
  };

  pythonImportsCheck = [
    "bitstruct"
  ];

  meta = with lib; {
    description = "Python bit pack/unpack package";
    homepage = "https://github.com/eerimoq/bitstruct";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
