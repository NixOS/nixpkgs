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
  version = "0.13.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bfacdcadd7903ed6afce6168e1977e473b431677b358f8fd42e80b48cedd19ab";
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
