{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, async-timeout
, lxml
}:

buildPythonPackage rec {
  pname = "pytrafikverket";
  version = "0.2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RsB8b96aCIBM3aABOuuexB5fIo7H1Kq/XsGvV8b7/sA=";
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
