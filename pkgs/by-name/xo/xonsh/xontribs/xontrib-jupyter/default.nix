{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  poetry-core,
  jupyter-client,
  writableTmpDirAsHomeHook,
  pytestCheckHook,
  xonsh,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "xontrib-jupyter";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xonsh";
    repo = "xontrib-jupyter";
    tag = "v${version}";
    hash = "sha256-gf+jyA2il7MD+Moez/zBYpf4EaPiNcgr5ZrJFK4uD2k=";
  };

  prePatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'xonsh = ">=0.12"' ""

    substituteInPlace xonsh_jupyter/shell.py \
      --replace-fail 'xonsh.base_shell' 'xonsh.shells.base_shell'
  '';

  build-system = [
    poetry-core
  ];

  dependencies = [
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
    maintainers = with lib.maintainers; [ greg ];
  };
}
