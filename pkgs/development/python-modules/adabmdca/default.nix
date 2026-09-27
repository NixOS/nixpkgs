{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  matplotlib,
  numpy,
  pandas,
  torch,
  tqdm,
  wandb,
  biopython,
  seaborn,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "adabmDCA";
  version = "0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "spqb";
    repo = "adabmDCApy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DlNL6Arng/tK3CmtsiCZ7Ff2xcwdB0vZLU/tAyXrufY=";
  };

  build-system = [ setuptools ];
  dependencies = [
    matplotlib
    numpy
    pandas
    torch
    tqdm
    wandb
    # biopython
    # TODO: TEMPORARY, disable broken biopython check
    (biopython.overrideAttrs (old: {
      doInstallCheck = false;
      meta = old.meta // {
        broken = false;
      };
    }))
    seaborn
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python GPU implementation of adabmDCA 2.0";
    homepage = "https://github.com/spqb/adabmDCApy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
