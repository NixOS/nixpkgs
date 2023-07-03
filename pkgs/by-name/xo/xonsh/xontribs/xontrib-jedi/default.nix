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
  version = "0.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "xonsh";
    repo = "xontrib-jedi";
    rev = "v${version}";
    hash = "sha256-bHVSIN+V4dhKPgNURkvMQyAbz49gEgYtJ1LqDLo0wYY=";
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
    substituteInPlace tests/test_jedi.py \
      --replace "/usr/bin" "${jedi}/bin"
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
