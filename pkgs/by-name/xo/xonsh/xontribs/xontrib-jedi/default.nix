{
  buildPythonPackage,
  lib,
  fetchFromGitHub,

  jedi,
  poetry-core,
  pytestCheckHook,
  xonsh,
}:

buildPythonPackage rec {
  pname = "xontrib-jedi";
  version = "0.0.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "xonsh";
    repo = "xontrib-jedi";
    rev = "v${version}";
    hash = "sha256-os5Stogtvj1jjh2gwSvfiAho83rSpVdWYNjoXHsOk4M=";
  };

  prePatch = ''
    substituteInPlace pyproject.toml \
      --replace 'xonsh = ">=0.12"' ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    jedi
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  checkInputs = [
    pytestCheckHook
    xonsh
  ];

  meta = with lib; {
    description = "Xonsh Python mode completions using jedi";
    homepage = "https://github.com/xonsh/xontrib-jedi";
    license = licenses.mit;
    maintainers = [ maintainers.greg ];
  };
}
