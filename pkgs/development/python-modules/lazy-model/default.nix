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

let
  version = "0.4.0";
  src = fetchFromGitHub {
    owner = "BeanieODM";
    repo = "lazy_model";
    tag = "v${version}";
    hash = "sha256-2DeGBSoElCGWJDqvYHLK2Zy+ep2kHV56rDYU2P4mEco=";
  };
in
buildPythonPackage {
  pname = "lazy-model";
  inherit version src;
  pyproject = true;

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
    teams = with lib.teams; [ deshaw ];
  };
}
