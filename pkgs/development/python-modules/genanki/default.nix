{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, cached-property, frozendict, pystache, pyyaml, pytest, pytestrunner
}:

buildPythonPackage rec {
  pname = "genanki";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c7c6c276f182a63a807b52a95f197df12794ff014f48dd287cb51ca2dcbe1b34";
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
