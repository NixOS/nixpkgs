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
  version = "20.11.1517005";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10b8ddhd77ixxi2i8mw86m388smp324f7rr0mdpkwdb0ra99ra8m";
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
