{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, cached-property, frozendict, pystache, pyyaml, pytest, pytestrunner
}:

buildPythonPackage rec {
  pname = "genanki";
  version = "0.6.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6d17761e06aca2d9acb588acfdce33fd3d05571338825760622c99fc7210f15a";
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
