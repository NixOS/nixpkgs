{
  buildPythonPackage,
  lib,
  fetchFromGitHub,

  pytestCheckHook,
  xonsh,
}:

buildPythonPackage rec {
  pname = "xontrib-whole-word-jumping";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "xonsh";
    repo = "xontrib-whole-word-jumping";
    rev = version;
    hash = "sha256-zLAOGW9prjYDQBDITFNMggn4X1JTyAnVdjkBOH9gXPs=";
  };

  prePatch = ''
    substituteInPlace pyproject.toml \
      --replace '"xonsh>=0.12.5", ' ""
  '';

  preCheck = ''
    export HOME=$TMPDIR
  '';

  checkInputs = [
    pytestCheckHook
    xonsh
  ];

  meta = with lib; {
    description = "Additional keyboard navigation for interactive xonsh shells";
    homepage = "https://github.com/xonsh/xontrib-whole-word-jumping";
    license = licenses.mit;
    maintainers = [ maintainers.greg ];
  };
}
