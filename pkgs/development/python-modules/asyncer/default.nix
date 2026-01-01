{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pdm-backend,
  anyio,
  typing-extensions,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "asyncer";
<<<<<<< HEAD
  version = "0.0.12";
=======
  version = "0.0.10";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fastapi";
    repo = "asyncer";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-ViPCy9N93qcpaAeawuUoSnLiW1jVGFM14K9LC/AQ+Fc=";
=======
    hash = "sha256-LjQOhcnCwM4Vcw+lBq6bexPYewRuhkU/R/pkDTEVHWQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ pdm-backend ];

  dependencies = [
    anyio
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "asyncer" ];

  meta = {
    description = "Asyncer, async and await, focused on developer experience";
    homepage = "https://github.com/fastapi/asyncer";
    changelog = "https://github.com/fastapi/asyncer/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
  };
}
