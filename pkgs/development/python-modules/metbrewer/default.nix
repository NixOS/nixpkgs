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
  version = "1,0.2";
  format = "setuptools";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "BlakeRMills";
    repo = "MetBrewer";
    rev = "${finalAttrs.version}";
    hash = "sha256-yjK067ICn9ZoPAKkTbbTnO6TA0d0xNRRwQ1hOC2I2E4=";
  };

  sourceRoot = "${finalAttrs.src.name}/Python";

  dependencies = [
    colour
    matplotlib
  ];

  preCheck = ''
    # silence matplotlib warning
    export MPLCONFIGDIR=$(mktemp -d)
  '';

  pythonImportsCheck = [
    "met_brewer"
  ];

  meta = {
    homepage = "https://github.com/BlakeRMills/MetBrew";
    description = "Palettes inspired by works at the Metropolitan Museum of Art in New York.";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ grandjeanlab ];
  };
})
