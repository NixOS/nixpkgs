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
  version = "0.5.11";

  src = fetchFromGitHub {
    owner = "randy3k";
    repo = pname;
    rev = "c1579e6b3fa1c302961d08debe17232127616b9b";
    sha256 = "SAVZgdLv7DZNwfvbu98m3cSZuv/XrRRZXHTT+58z8Ao=";
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
    description = "A 21 century R console.";
    homepage = "https://github.com/randy3k/radian";
    license = licenses.mit;
    maintainers = with maintainers; [ jdreaver ];
  };
}
