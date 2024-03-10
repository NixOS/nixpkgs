{ qtModule
, fetchFromGitHub
, qtbase
}:

qtModule rec {
  pname = "qtmqtt";
  version = "6.6.2";

  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtmqtt";
    rev = "v${version}";
    hash = "sha256-R8B7Vt/XzI7+17DDZ+TVbqfGKdEfUMiLa1BqzIbo4OM=";
  };

  propagatedBuildInputs = [ qtbase ];
}
