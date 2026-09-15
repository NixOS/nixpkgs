{
  buildPythonPackage,
  fetchFromGitHub,
  lib,

  # build system
  poetry-core,

  # dependencies
  pydantic,

  # test dependencies
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "lazy-model";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BeanieODM";
    repo = "lazy_model";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2DeGBSoElCGWJDqvYHLK2Zy+ep2kHV56rDYU2P4mEco=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    pydantic
  ];

  pythonImportsCheck = [ "lazy_model" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Lazy parsing for Pydantic models";
    homepage = "https://github.com/BeanieODM/lazy_model";
    license = lib.licenses.asl20;
  };
})
