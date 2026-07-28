{
  lib,
  buildPythonPackage,
  cached-property,
  chevron,
  fetchPypi,
  frozendict,
  pystache,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "genanki";
  version = "0.13.1";
  format = "setuptools";

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

  pythonImportsCheck = [ "genanki" ];

  meta = {
    description = "Generate Anki decks programmatically";
    homepage = "https://github.com/kerrickstaley/genanki";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ teto ];
  };
}
