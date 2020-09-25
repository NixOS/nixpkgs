{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, click, click-datetime, deprecation
, pytest, voluptuous }:

buildPythonPackage rec {
  pname = "pyHS100";
  version = "0.3.5.1";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "GadgetReactor";
    repo = pname;
    rev = version;
    sha256 = "1vddr9sjn6337i1vx0mm7pb3qibvl2gx6nx18vm4fajgv9vcjxny";
  };

  propagatedBuildInputs = [
    click
    click-datetime
    deprecation
  ];

  checkInputs = [
    pytest
    voluptuous
  ];

  checkPhase = ''
    py.test pyHS100
  '';

  meta = with lib; {
    description = "Python Library to control TPLink Switch (HS100 / HS110)";
    homepage = "https://github.com/GadgetReactor/pyHS100";
    license = licenses.gpl3;
    maintainers = with maintainers; [ hexa ];
  };
}
