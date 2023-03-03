{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, click, click-datetime, deprecation
, pytest, voluptuous }:

buildPythonPackage rec {
  pname = "pyHS100";
  version = "0.3.5.2";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "GadgetReactor";
    repo = pname;
    rev = version;
    sha256 = "0z98hzvkp6jmllyd4x4y0f5n6nnxrizw6g5l2clxdn93mifjavp0";
  };

  propagatedBuildInputs = [
    click
    click-datetime
    deprecation
  ];

  nativeCheckInputs = [
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
