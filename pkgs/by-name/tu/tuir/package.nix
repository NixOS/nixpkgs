{
  lib,
  fetchFromGitLab,
  python3Packages,
}:

with python3Packages;
buildPythonApplication rec {
  pname = "tuir";
  version = "1.31.0";

  src = fetchFromGitLab {
    owner = "Chocimier";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-VYBtD3Ex6+iIRNvX6jF0b0iPvno41/58xCRydiyssvk=";
  };

  # Tests try to access network
  doCheck = false;

  checkPhase = ''
    py.test
  '';

  nativeCheckInputs = [
    coverage
    coveralls
    docopt
    mock
    pylint
    pytest
    vcrpy
  ];

  propagatedBuildInputs = [
    beautifulsoup4
    decorator
    kitchen
    mailcap-fix
    requests
    six
  ];

  meta = with lib; {
    description = "Browse Reddit from your Terminal (fork of rtv)";
    mainProgram = "tuir";
    homepage = "https://gitlab.com/Chocimier/tuir";
    license = licenses.mit;
    maintainers = with maintainers; [
      Br1ght0ne
      matthiasbeyer
      brokenpip3
    ];
  };
}
