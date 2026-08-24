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
  version = "3.33.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pirl-unc";
    repo = "mhcgnomes";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WcYSSgzSOFmgZEX9TZSQAITWxpIjNG1/b6t1RXjfGKs=";
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
