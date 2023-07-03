{
  buildPythonPackage,
  lib,
  fetchFromGitHub,

  pytestCheckHook,
  xonsh,
}:

buildPythonPackage rec {
  pname = "xontrib-debug-tools";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "xonsh";
    repo = "xontrib-debug-tools";
    rev = version;
    hash = "sha256-Z8AXKk94NxmF5rO2OMZzNX0GIP/Vj+mOtYUaifRX1cw=";
  };

  prePatch = ''
    substituteInPlace pyproject.toml \
      --replace '"xonsh>=0.12.5"' ""
  '';

  preCheck = ''
    export HOME=$TMPDIR
  '';

  checkInputs = [
    pytestCheckHook
    xonsh
  ];

  meta = with lib; {
    description = "Debug tools for xonsh shell.";
    homepage = "https://github.com/xonsh/xontrib-debug-tools";
    license = licenses.mit;
    maintainers = [ maintainers.greg ];
  };
}
