{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  pdm-backend,
  acres,
  click,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "bidsschematools";
  version = "1.0.13";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "bidsschematools";
    inherit version;
    hash = "sha256-l9DN68kf1HwE0Th6XBuLxlikAyaARIEK/jwE6/mC0Vo=";
  };

  build-system = [
    pdm-backend
  ];

  dependencies = [
    acres
    click
    pyyaml
  ];

  pythonImportsCheck = [
    "bidsschematools"
  ];

  meta = {
    description = "Python tools for working with the BIDS schema";
    homepage = "https://github.com/bids-standard/bids-specification/tree/master/tools/schemacode";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
