{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  pkgs,

  jupyter-client,
  poetry-core,
  pytestCheckHook,
  xonsh,
}:

buildPythonPackage rec {
  pname = "xontrib-jupyter";
  version = "0.3.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "xonsh";
    repo = "xontrib-jupyter";
    rev = "v${version}";
    hash = "sha256-2+N6bEXcZfviGNf20VJOPdh/L8kDeSktvnKMuQEo37U=";
  };

  prePatch = ''
    substituteInPlace pyproject.toml \
      --replace 'xonsh = ">=0.12"' ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    jupyter-client
  ];

  preCheck = "export HOME=/tmp";

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
