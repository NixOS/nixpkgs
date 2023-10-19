{ qtModule
, fetchFromGitHub
, qtbase
}:

qtModule rec {
  pname = "qtmqtt";
  version = "6.6.0";
  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtmqtt";
    rev = "v${version}";
    hash = "sha256-rFi1w0Z4jLvHvhu0/VOIT0MWmKjy51jSK5M56qLs0gI=";
  };
  qtInputs = [ qtbase ];
}
