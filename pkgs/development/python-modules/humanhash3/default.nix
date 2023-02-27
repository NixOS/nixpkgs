{ lib
, fetchPypi
, python
, buildPythonPackage
, pythonOlder
}:

buildPythonPackage rec {
  pname = "humanhash3";
  version = "0.0.6";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    hash = "sha256-ia4V9gNL2wflOsKy4kbMcTGUB2bSsrcLc5jdJ8ZAsas=";
  };

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "humanhash" ];

  meta = with lib; {
    description = "Provides human-readable representations of digests";
    homepage = "https://github.com/blag/humanhash";
    license = licenses.unlicense;
    maintainers = with maintainers; [ FaustXVI ];
  };
}
