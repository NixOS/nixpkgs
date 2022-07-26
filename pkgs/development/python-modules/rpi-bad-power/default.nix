{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

let
  pname = "rpi-bad-power";
  version = "0.1.0";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "shenxn";
    repo = pname;
    rev = "v${version}";
    hash = "sha256:1yvfz28blq4fdnn614n985vbs5hcw1gm3i9am53k410sfs7ilvkk";
  };

  pythonImportsCheck = [
    "rpi_bad_power"
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Python library to detect bad power supply on Raspberry Pi";
    homepage = "https://github.com/shenxn/rpi-bad-power";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
    platforms = platforms.linux;
  };
}
