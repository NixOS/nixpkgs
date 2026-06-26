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
  version = "1.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bids-standard";
    repo = "bids-specification";
    tag = "schema-${finalAttrs.version}";
    hash = "sha256-imgY2aDSQjS3Yjxv7iq31+qFrOCMXfYdS4Tt8lhMosI=";
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
