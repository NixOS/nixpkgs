{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "pyfreedompro";
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-koEgcKDHR2H6DIysmN2+C8p4HI3oDisI29BEkugxwXI=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "aiohttp" ];

  meta = with lib; {
    description = "Python library for Freedompro API";
    homepage = "https://github.com/stefano055415/pyfreedompro";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
