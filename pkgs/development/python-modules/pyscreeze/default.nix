{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pillow,
  xlib,
  xvfb-run,
  scrot,
}:
buildPythonPackage rec {
  pname = "pyscreeze";
  version = "0.1.26";

  src = fetchFromGitHub {
    owner = "asweigart";
    repo = "pyscreeze";
    rev = "28ab707dceecbdd135a9491c3f8effd3a69680af";
    hash = "sha256-gn3ydjf/msdhIhngGlhK+jhEyFy0qGeDr58E7kM2YZs=";
  };

  pythonImportsCheck = [ "pyscreeze" ];
  nativeCheckInputs = [
    scrot
    xlib
    xvfb-run
  ];
  checkPhase = ''
    python -m unittest tests.test_pillow_unavailable
    xvfb-run python -m unittest tests.test_pyscreeze
  '';

  propagatedBuildInputs = [ pillow ];

  meta = with lib; {
    description = "PyScreeze is a simple, cross-platform screenshot module for Python 2 and 3.";
    homepage = "https://github.com/asweigart/pyscreeze";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lucasew ];
  };
}
