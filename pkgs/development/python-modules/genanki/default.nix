{ lib, buildPythonPackage, fetchPypi, isPy3k
, cached-property, frozendict, pystache, pyyaml, pytest, pytest-runner
}:

buildPythonPackage rec {
  pname = "genanki";
  version = "0.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f2be87e3c2850bba21627d26728238f9655b448e564f8c70ab47caef558b63ef";
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
