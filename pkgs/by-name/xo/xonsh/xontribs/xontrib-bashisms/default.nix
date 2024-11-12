{
  buildPythonPackage,
  lib,
  fetchFromGitHub,

  setuptools,
  pytestCheckHook,
  xonsh,
}:

buildPythonPackage rec {
  pname = "xontrib-bashisms";
  version = "0.0.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "xonsh";
    repo = "xontrib-bashisms";
    rev = version;
    hash = "sha256-R1DCGMrRCJLnz/QMk6QB8ai4nx88vvyPdaCKg3od5/I=";
  };

  prePatch = ''
    substituteInPlace pyproject.toml \
      --replace '"xonsh>=0.12.5"' ""
  '';

  preCheck = ''
    export HOME=$TMPDIR
  '';

  nativeBuildInputs = [
    setuptools
  ];

  checkInputs = [
    pytestCheckHook
    xonsh
  ];

  meta = with lib; {
    description = "Bash-like interactive mode extensions for the xonsh shell. ";
    homepage = "https://github.com/xonsh/xontrib-bashisms";
    license = licenses.mit;
    maintainers = [ maintainers.greg ];
  };
}
