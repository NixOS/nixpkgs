{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, cached-property, frozendict, pystache, pyyaml, pytest, pytestrunner
}:

buildPythonPackage rec {
  pname = "genanki";
  version = "0.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2408f7d9955c8963fd9b1ecbb873f5d18dee786e060dcb083aef5dd86c736773";
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
    homepage = https://github.com/kerrickstaley/genanki;
    description = "Generate Anki decks programmatically";
    license = licenses.mit;
    maintainers = with maintainers; [ teto ];
  };
}
