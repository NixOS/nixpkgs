{ lib
, buildPythonPackage
, fetchFromGitHub
, six
, pytestCheckHook
}:

let
  pname = "adapt-parser";
  version = "1.0.0";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "MycroftAI";
    repo = "adapt";
    rev = "release/v${version}";
    hash = "sha256-1BDVhcjgf3OTrIwwKZnFxmtUUkwhfhYc+/pElQrVips=";
  };

  propagatedBuildInputs = [
    six
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "test/*"
  ];

  pythonImportsCheck = [
    "adapt"
  ];

  meta = with lib; {
    description = "Adapt Intent Parser";
    homepage = "https://github.com/MycroftAI/adapt";
    license = licenses.asl20;
    maintainers = teams.mycroft.members;
  };
}
