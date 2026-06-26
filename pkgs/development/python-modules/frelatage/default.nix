{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  poetry-core,
  pytestCheckHook,
  timeout-decorator,
}:

buildPythonPackage rec {
  pname = "frelatage";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Rog3rSm1th";
    repo = "frelatage";
    tag = "v${version}";
    hash = "sha256-eHVqp6govBV9FvSQyaZuEEImHQRs/mbLaW86RCvtDbM=";
  };

  pythonRelaxDeps = [ "numpy" ];

  build-system = [ poetry-core ];

  dependencies = [
    numpy
    timeout-decorator
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "frelatage" ];

  meta = {
    description = "Greybox and Coverage-based library to fuzz Python applications";
    homepage = "https://github.com/Rog3rSm1th/frelatage";
    changelog = "https://github.com/Rog3rSm1th/frelatage/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
