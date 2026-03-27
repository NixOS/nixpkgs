{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  pandas,
  pyyaml,
  numpy,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mhcgnomes";
  version = "3.15.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pirl-unc";
    repo = "mhcgnomes";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tcJfGIJsbCdN+U/+2zsYBhKEJNy55QMf7eu9Z4nuXlk=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pandas
    pyyaml
    numpy
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
  };
})
