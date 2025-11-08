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
  version = "1.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bids-standard";
    repo = "bids-specification";
    tag = "schema-${version}";
    hash = "sha256-b4dRGXkRkV+vmQ91fM8FMQv8iOt35dyf5unOEKNbNPc=";
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
