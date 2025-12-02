{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pdm-backend,
  acres,
  click,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "bidsschematools";
  version = "1.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bids-standard";
    repo = "bids-specification";
    tag = "schema-${version}";
    hash = "sha256-77ctT1Btin9gJSfgu1euFep0lg6SauCZn60VRrJ0IRk=";
  };

  sourceRoot = "${src.name}/tools/schemacode";

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
