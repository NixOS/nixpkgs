{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pyte
, pexpect
, ptyprocess
, jedi
, git
, lineedit
, prompt-toolkit
, pygments
, rchitect
, six
, R
, rPackages
}:

buildPythonPackage rec {
  pname = "radian";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "randy3k";
    repo = pname;
    rev = "v${version}";
    sha256 = "iuD4EkGZ1GwNxR8Gpg9ANe3lMHJYZ/Q/RyuN6vZZWME=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace '"pytest-runner"' ""
  '';

  nativeBuildInputs = [
    R # needed at setup time to detect R_HOME
  ];

  propagatedBuildInputs = [
    lineedit
    prompt-toolkit
    pygments
    rchitect
    six
  ] ++ (with rPackages; [
    reticulate
    askpass
  ]);

  nativeCheckInputs = [
    pytestCheckHook
    pyte
    pexpect
    ptyprocess
    jedi
    git
  ];

  preCheck = ''
    export HOME=$TMPDIR
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${R}/lib/R/lib
  '';

  pythonImportsCheck = [ "radian" ];

  meta = with lib; {
    description = "A 21 century R console";
    homepage = "https://github.com/randy3k/radian";
    license = licenses.mit;
    maintainers = with maintainers; [ savyajha ];
  };
}
