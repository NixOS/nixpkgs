{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "lightwave2";
  version = "0.8.23";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-umhFqeX16c6o006MU9/9h4EnqcX7v8C5q3XjxYgi+xk=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "lightwave2" ];

  meta = {
    description = "Library to interact with LightWaveRF 2nd Gen lights and switches";
    homepage = "https://github.com/bigbadblunt/lightwave2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
