{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "poolsense";
  version = "0.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WCyuhk77QNJAiuzccrb2u0mfc81LYrYSSq9atgO0LdE=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "poolsense" ];

  meta = {
    description = "Python module to access PoolSense device";
    homepage = "https://github.com/haemishkyd/poolsense";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
