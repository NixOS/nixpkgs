{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools,
  click,
  pyyaml,
  jsonschema,
}:

buildPythonPackage rec {
  pname = "bidsschematools";
  version = "1.0.5";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "bidsschematools";
    inherit version;
    hash = "sha256-LKStxCh7TY7rSx6T9EnPJqCNxuj5dHvlK6E+m8D21BE=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    click
    pyyaml
    jsonschema
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
