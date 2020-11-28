{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, cached-property, frozendict, pystache, pyyaml, pytest, pytestrunner
}:

buildPythonPackage rec {
  pname = "genanki";
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c944b74a5735e30ce098149788b89192fb3ba162fefb30f62105451a4a5b4c62";
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
