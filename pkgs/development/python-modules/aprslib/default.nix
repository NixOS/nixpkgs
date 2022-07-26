{ lib
, buildPythonPackage
, fetchFromGitHub
, mox3
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aprslib";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "rossengeorgiev";
    repo = "aprs-python";
    rev = "v${version}";
    hash = "sha256-wWlzOFhWJ7hJeM3RWsPTEsLjRzN4SMXsb2Cd612HB4w=";
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
