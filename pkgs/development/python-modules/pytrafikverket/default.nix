{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, async-timeout
, lxml
}:

buildPythonPackage rec {
  pname = "pytrafikverket";
  version = "0.1.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hrjsw53ixgmhsiszdrzzh0wma705nrhq8npzacsyaf43r29zvqy";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    lxml
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pytrafikverket" ];

  meta = with lib; {
    description = "Python library to manage Etekcity Devices and Levoit Air Purifier";
    homepage = "https://github.com/endor-force/pytrafikverket";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
