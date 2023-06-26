{ qtModule
, fetchFromGitHub
, qtbase
}:

qtModule rec {
  pname = "qtmqtt";
  version = "6.5.1";
  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtmqtt";
    rev = "v${version}";
    hash = "sha256-tXCLb4ZWgdPSfnlGKsKNW9kJ57cm8+d8y416O42NZvk=";
  };
  qtInputs = [ qtbase ];
}
