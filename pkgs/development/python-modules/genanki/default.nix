{ lib
, buildPythonPackage
, cached-property
, chevron
, fetchPypi
, frozendict
, pystache
, pythonOlder
, pyyaml
}:

buildPythonPackage rec {
  pname = "genanki";
  version = "0.13.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hNCQQjqIeVIEZb/peECD7ay4014rpRH6Whve8B2Pce0=";
  };

  propagatedBuildInputs = [
    cached-property
    chevron
    frozendict
    pystache
    pyyaml
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'," ""
  '';

  # relies on upstream anki
  doCheck = false;

  pythonImportsCheck = [
    "genanki"
  ];

  meta = with lib; {
    description = "Generate Anki decks programmatically";
    homepage = "https://github.com/kerrickstaley/genanki";
    license = licenses.mit;
    maintainers = with maintainers; [ teto ];
  };
}
