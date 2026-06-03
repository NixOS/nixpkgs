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
    rev = "v${finalAttrs.version}";
    sha256 = "0v03gly5k3a1hzb54zpw6409m3riak49qd27hkq2f66ai42ivqz2";
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
