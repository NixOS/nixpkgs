{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
}:

buildPythonPackage rec {
  pname = "konnected";
  version = "1.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b8b4e15c3228b01c9fad3651e09fea1654357ae8c333096e759a1b7d0eb4e789";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

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
