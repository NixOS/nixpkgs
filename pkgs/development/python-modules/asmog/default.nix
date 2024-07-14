{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "asmog";
  version = "0.0.6";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-k8dC3g2oY/b4w4m7Y/HUy/6/3Tm1kntx9tjoyXqDaJE=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # Project doesn't ship the tests
  # https://github.com/kstaniek/python-ampio-smog-api/issues/2
  doCheck = false;

  pythonImportsCheck = [ "asmog" ];

  meta = with lib; {
    description = "Python module for Ampio Smog Sensors";
    homepage = "https://github.com/kstaniek/python-ampio-smog-api";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
