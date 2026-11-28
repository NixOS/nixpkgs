{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  argcomplete,
  pandas,
  pyyaml,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mhcgnomes";
  version = "3.96.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pirl-unc";
    repo = "mhcgnomes";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j3+Zh0NM6OWCfT6TFcCqIXBKzvWk0DFiddTJpcGRNrw=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    argcomplete
    pandas
    pyyaml
  ];

  pythonImportsCheck = [ "mhcgnomes" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Parsing MHC nomenclature in the wild";
    homepage = "https://github.com/pirl-unc/mhcgnomes";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ samuela ];
    mainProgram = "mhcgnomes";
  };
})
