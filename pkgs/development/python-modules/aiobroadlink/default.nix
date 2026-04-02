{
  lib,
  buildPythonPackage,
  cryptography,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "aiobroadlink";
  version = "0.1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uTUtDhL9VtWZE+Y6ZJY4prmlE+Yh2UrCg5+eSyAQzMk=";
  };

  propagatedBuildInputs = [ cryptography ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aiobroadlink" ];

  meta = {
    description = "Python module to control various Broadlink devices";
    mainProgram = "aiobroadlink";
    homepage = "https://github.com/frawau/aiobroadlink";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
