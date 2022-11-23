{ lib
, buildPythonPackage
, fetchFromGitHub
, lineedit
, pexpect
, ptyprocess
, pygments
, pyte
, pytestCheckHook
, R
, rchitect
, six
}:

buildPythonPackage rec {
  pname = "radian";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "randy3k";
    repo = pname;
    rev = "v${version}";
    sha256 = "QEHVdyVgsZxvs+d+xeeJqwx531+6e0uPi1J3t+hJ0d0=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace '"pytest-runner"' ""
  '';

  checkInputs = [
    pytestCheckHook
    pyte
    pexpect
    ptyprocess
  ];

  nativeBuildInputs = [
    R # needed at setup time to detect R_HOME
  ];

  # Tests fail in mysterious ways with empty exception values
  doCheck = false;

  propagatedBuildInputs = [
    lineedit
    pygments
    rchitect
    six
  ];

  pythonImportsCheck = [ "radian" ];

  meta = with lib; {
    description = "A 21 century R console";
    homepage = "https://github.com/randy3k/radian";
    license = licenses.mit;
    maintainers = with maintainers; [ jdreaver ];
  };
}
