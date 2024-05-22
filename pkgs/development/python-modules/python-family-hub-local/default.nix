{
  lib,
  buildPythonPackage,
  aiohttp,
  async-timeout,
  pillow,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "python-family-hub-local";
  version = "0.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-bbOBlUJ4g+HOcJihEBAz3lsHR9Gn07z8st14FRFeJbc=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    pillow
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyfamilyhublocal" ];

  meta = with lib; {
    description = "Module to accesse information from Samsung FamilyHub fridges locally";
    homepage = "https://github.com/Klathmon/python-family-hub-local";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
