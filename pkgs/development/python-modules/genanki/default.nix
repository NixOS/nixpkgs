{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, cached-property, frozendict, pystache, pyyaml, pytest, pytestrunner
}:

buildPythonPackage rec {
  pname = "genanki";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08eddb4a203e36e4fc3b66f85e00252070379867dbbc04fd8902ddc14fb352c6";
  };

  propagatedBuildInputs = [
		pytestrunner
    cached-property
    frozendict
    pystache
    pyyaml
  ];

  checkInputs = [ pytest ];

  disabled = !isPy3k;

  # relies on upstream anki
	doCheck = false;
  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/kerrickstaley/genanki";
    description = "Generate Anki decks programmatically";
    license = licenses.mit;
    maintainers = with maintainers; [ teto ];
  };
}
