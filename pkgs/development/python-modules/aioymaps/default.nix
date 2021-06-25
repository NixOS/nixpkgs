{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioymaps";
  version = "1.1.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rvgf4flvnpjj0sm14xlnfmmnlmkz6xq5h5mfb14amkfy76za3jm";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aioymaps" ];

  meta = with lib; {
    description = "Python package fetch data from Yandex maps";
    homepage = "https://github.com/devbis/aioymaps";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
