{ lib
, buildPythonPackage
, fetchFromGitHub
, mox3
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aprslib";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "rossengeorgiev";
    repo = "aprs-python";
    rev = "v${version}";
    sha256 = "sha256-QasyF0Ch4zdPoAgcqRavEENVGA/02/AgeWAgXYcSUjk=";
  };

  checkInputs = [
    mox3
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aprslib" ];

  meta = with lib; {
    description = "Module for accessing APRS-IS and parsing APRS packets";
    homepage = "https://github.com/rossengeorgiev/aprs-python";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
