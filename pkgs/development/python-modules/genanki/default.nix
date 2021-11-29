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
  version = "0.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f787ac440ff37a3ef3389030e992e3527f000f7a69498f797033ccfad07ebe62";
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
