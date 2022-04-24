{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "precis-i18n";
  version = "1.0.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "byllyfish";
    repo = "precis_i18n";
    rev = "v${version}";
    hash = "sha256-90yNusUyz8qJi7WWYIFhHzrpvu1TqxfpT+lv2CVhSR8=";
  };

  pythonImportsCheck = [
    "precis_i18n"
  ];

  meta = with lib; {
    homepage = "https://github.com/byllyfish/precis_i18n";
    description = "Internationalized usernames and passwords";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
