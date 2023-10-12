{ qtModule
, fetchFromGitHub
, qtbase
}:

qtModule rec {
  pname = "qtmqtt";
  version = "6.5.3";
  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtmqtt";
    rev = "v${version}";
    hash = "sha256-F0rq72Cvnwy2cJmw3wUL9t8ZsnI61HBRMMWRwKdSEs8=";
  };
  qtInputs = [ qtbase ];
}
