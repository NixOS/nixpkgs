{ buildPythonPackage
, fetchPypi
, lib
, pythonOlder

# Python dependencies
, uvloop
, pytest
}:

buildPythonPackage rec {
  pname = "aioextensions";
  version = "20.11.1621472";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "abfb2a27590f20b04808192e6c9c5f93298656c013546850c4505b5070a8cc82";
  };

  propagatedBuildInputs = [ uvloop ];

  checkInputs = [ pytest ];
  checkPhase = ''
    cd test/
    pytest
  '';

  meta = with lib; {
    description = "High performance functions to work with the async IO";
    homepage = "https://kamadorueda.github.io/aioextensions";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
