{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, lxml
}:

buildPythonPackage rec {
  pname = "pykmtronic";
  version = "0.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8bxn27DU1XUQUxQFJklEge29DHx1DMu7pJG4hVE1jDU=";
  };

  propagatedBuildInputs = [ aiohttp lxml ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pykmtronic" ];

  meta = with lib; {
    description = "Python client to interface with KM-Tronic web relays";
    homepage = "https://github.com/dgomes/pykmtronic";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
