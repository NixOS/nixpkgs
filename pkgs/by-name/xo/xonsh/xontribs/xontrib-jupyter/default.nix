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
    owner = "greg-hellings";
    repo = "xontrib-jupyter";
    # https://github.com/xonsh/xontrib-jupyter/pull/37
    rev = "add_kwargs";
    hash = "sha256-12IMDUIoW265asXrw8sikfWFFWZXPAF54fQr2lSjZVk=";
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
