{
  lib,
  buildPythonPackage,
  fetchPypi,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "konnected";
  version = "1.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uLThXDIosByfrTZR4J/qFlQ1eujDMwludZobfQ6054k=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "konnected" ];

  meta = with lib; {
    description = "Async Python library for interacting with Konnected home automation controllers";
    homepage = "https://github.com/konnected-io/konnected-py";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
