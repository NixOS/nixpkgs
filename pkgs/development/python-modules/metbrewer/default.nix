{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # dependencies
  colour,
  matplotlib,
}:

buildPythonPackage (finalAttrs: {
  pname = "metbrewer";
  version = "0-unstable-2025-01-03";
  format = "setuptools";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "BlakeRMills";
    repo = "MetBrewer";
    rev = "58839e5ac7c7d604c8704581f7b201a29986b814";
    hash = "sha256-yjK067ICn9ZoPAKkTbbTnO6TA0d0xNRRwQ1hOC2I2E4=";
  };

  sourceRoot = "${finalAttrs.src.name}/Python";

  dependencies = [
    colour
    matplotlib
  ];

  pythonImportsCheck = [
    "met_brewer"
  ];

  meta = {
    homepage = "https://github.com/BlakeRMills/MetBrewer";
    description = "Palettes inspired by works at the Metropolitan Museum of Art in New York.";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ grandjeanlab ];
  };
})
