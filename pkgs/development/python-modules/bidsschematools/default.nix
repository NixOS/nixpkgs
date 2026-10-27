{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pdm-backend,
  acres,
  click,
  pyyaml,
}:

buildPythonPackage (finalAttrs: {
  pname = "bidsschematools";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bids-standard";
    repo = "bids-specification";
    tag = "schema-${finalAttrs.version}";
    hash = "sha256-bhlg2IMaU2wclJqtbaUXC2IKgP2vbA6QbJu/zVDKVsc=";
  };

  sourceRoot = "${finalAttrs.src.name}/tools/schemacode";

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
})
