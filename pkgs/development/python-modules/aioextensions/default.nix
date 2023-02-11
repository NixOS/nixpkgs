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
  version = "21.7.2261349";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2eacc52692495f331437e8c8e9782ca71f4617ec84f174ca17acdd77631efc47";
  };

  propagatedBuildInputs = [ uvloop ];

  nativeCheckInputs = [ pytest ];
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
