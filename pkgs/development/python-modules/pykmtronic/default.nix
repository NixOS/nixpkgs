{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, lxml
}:

buildPythonPackage rec {
  pname = "pykmtronic";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8qLyBJp7C93x0PWbgDAtNEDJ5VLNfwZ3DRZfudRCBgo=";
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
