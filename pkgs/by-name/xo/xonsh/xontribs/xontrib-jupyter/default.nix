{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  hatchling,
  hatch-vcs,
  ipykernel,
  jupyter-client,
  writableTmpDirAsHomeHook,
  pytestCheckHook,
  xonsh,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "xontrib-jupyter";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xonsh";
    repo = "xontrib-jupyter";
    tag = "v${version}";
    hash = "sha256-3Nmp7fmIgRvSpxog3Hu9jyqYzC/m/jnmEgmvPZvFCT8=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    ipykernel
    jupyter-client
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    pytestCheckHook
    xonsh
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Xonsh jupyter kernel allows to run Xonsh shell code in Jupyter, JupyterLab, Euporia, etc";
    homepage = "https://github.com/xonsh/xontrib-jupyter";
    changelog = "https://github.com/xonsh/xontrib-jupyter/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      greg
      infinidoge
    ];
  };
}
