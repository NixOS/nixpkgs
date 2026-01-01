{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  timeout-decorator,
}:

buildPythonPackage rec {
  pname = "frelatage";
  version = "0.1.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

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

<<<<<<< HEAD
  meta = {
    description = "Greybox and Coverage-based library to fuzz Python applications";
    homepage = "https://github.com/Rog3rSm1th/frelatage";
    changelog = "https://github.com/Rog3rSm1th/frelatage/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Greybox and Coverage-based library to fuzz Python applications";
    homepage = "https://github.com/Rog3rSm1th/frelatage";
    changelog = "https://github.com/Rog3rSm1th/frelatage/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
