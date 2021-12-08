{ lib
, buildPythonPackage
, fetchFromGitHub
, cryptography
}:

buildPythonPackage rec {
  pname = "broadlink";
  version = "0.18.0";

  src = fetchFromGitHub {
     owner = "mjg59";
     repo = "python-broadlink";
     rev = "0.18.0";
     sha256 = "0nh9rn1zpc44qsc50360ycg02gwbgq59784mnkp01nhavnwwwx10";
  };

  propagatedBuildInputs = [
    cryptography
  ];

  # no tests available
  doCheck = false;

  pythonImportsCheck = [
    "broadlink"
  ];

  meta = with lib; {
    description = "Python API for controlling Broadlink IR controllers";
    homepage =  "https://github.com/mjg59/python-broadlink";
    license = licenses.mit;
  };
}
