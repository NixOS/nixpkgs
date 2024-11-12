{
  buildPythonPackage,
  lib,
  fetchFromGitHub,

  jupyter-client,
  poetry-core,
  pytestCheckHook,
  xonsh,
}:

buildPythonPackage rec {
  pname = "xontrib-jupyter";
  version = "0.3.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "xonsh";
    repo = "xontrib-jupyter";
    rev = "v${version}";
    hash = "sha256-gf+jyA2il7MD+Moez/zBYpf4EaPiNcgr5ZrJFK4uD2k=";
  };

  prePatch = ''
    substituteInPlace pyproject.toml \
      --replace 'xonsh = ">=0.12"' ""

    substituteInPlace xonsh_jupyter/shell.py \
      --replace 'xonsh.base_shell' 'xonsh.shells.base_shell'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    jupyter-client
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  checkInputs = [
    pytestCheckHook
    xonsh
  ];

  meta = with lib; {
    description = "Xonsh jupyter kernel allows to run Xonsh shell code in Jupyter, JupyterLab, Euporia, etc.";
    homepage = "https://github.com/xonsh/xontrib-jupyter";
    license = licenses.mit;
    maintainers = [ maintainers.greg ];
  };
}
