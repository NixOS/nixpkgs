{ lib, buildPythonPackage, fetchPypi, flit-core
, bottle, doreah, parse, waitress
}:

buildPythonPackage rec {
  pname = "nimrodel";
  version = "0.8.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-f9XVuvMXMAgqlDyDsZTF7Afquj9L/0U/4xVsN+VgtW0=";
  };

  nativeBuildInputs = [
    flit-core
  ];
  propagatedBuildInputs = [
    bottle
    doreah
    parse
    waitress
  ];

  meta = with lib; {
    homepage = "https://github.com/krateng/nimrodel";
    description = "A simple Bottle.py-wrapper to provide HTTP API access to any python object";
    license = licenses.gpl3;
    maintainers = with maintainers; [ avh4 ];
  };
}
