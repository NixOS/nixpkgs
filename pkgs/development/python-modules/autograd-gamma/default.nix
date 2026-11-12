{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  autograd,
  scipy,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "autograd-gamma";
  version = "0.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CamDavidsonPilon";
    repo = "autograd-gamma";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4uMdBYnKGCfwhEc0nMhUMY+aADH8flLWh0GNWTx9A2w=";
  };

  build-system = [ setuptools ];

  dependencies = [
    autograd
    scipy
  ];

  pythonImportsCheck = [ "autograd_gamma" ];

  checkInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://github.com/CamDavidsonPilon/autograd-gamma";
    description = "Autograd compatible approximations to the gamma family of functions";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ swflint ];
  };
})
