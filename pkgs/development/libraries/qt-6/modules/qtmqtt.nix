{ qtModule
, fetchFromGitHub
, qtbase
}:

qtModule rec {
  pname = "qtmqtt";
  version = "6.6.1";
  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtmqtt";
    rev = "v${version}";
    hash = "sha256-6jQrUT1wLk6rhDIns0ubdUCZ7e/m38Oqvl8c1/sfWxI=";
  };
  propagatedBuildInputs = [ qtbase ];
}
