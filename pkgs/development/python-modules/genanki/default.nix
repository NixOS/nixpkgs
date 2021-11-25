{ lib, buildPythonPackage, fetchPypi, isPy3k
, cached-property, frozendict, pystache, pyyaml, pytest, pytest-runner
}:

buildPythonPackage rec {
  pname = "genanki";
  version = "0.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f787ac440ff37a3ef3389030e992e3527f000f7a69498f797033ccfad07ebe62";
  };

  propagatedBuildInputs = [
    pytest-runner
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

  meta = with lib; {
    homepage = "https://github.com/kerrickstaley/genanki";
    description = "Generate Anki decks programmatically";
    license = licenses.mit;
    maintainers = with maintainers; [ teto ];
  };
}
