{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pyfido";
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b28bhyhscaw7dbc92dxswann05x8mz92cagyawdfm8jnc67gq4b";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pyfido" ];

  meta = with lib; {
    description = "Python client to get fido account data";
    homepage = "https://github.com/titilambert/pyfido";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
