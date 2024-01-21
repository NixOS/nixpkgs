{
  buildPythonPackage,
  lib,
  fetchFromGitHub,

  pytestCheckHook,
  pytest-subprocess,
  xonsh,
}:

buildPythonPackage rec {
  pname = "xontrib-fish-completer";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "xonsh";
    repo = "xontrib-fish-completer";
    rev = version;
    hash = "sha256-OB1O5GZYkg7Ucaqak3MncnQWXhMD4BM4wXsYCDD0mhk=";
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
    pytest-subprocess
    xonsh
  ];

  meta = with lib; {
    description = "Populate rich completions using fish and remove the default bash based completer";
    homepage = "https://github.com/xonsh/xontrib-fish-completer";
    license = licenses.mit;
    maintainers = [ maintainers.greg ];
  };
}
