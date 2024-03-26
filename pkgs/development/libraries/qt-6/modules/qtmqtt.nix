{ qtModule
, fetchFromGitHub
, qtbase
}:

qtModule rec {
  pname = "qtmqtt";
  version = "6.7.0-rc2";

  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtmqtt";
    rev = "v${version}";
    hash = "sha256-gszZ67ZAaZm2/bsFt6i5ECGyNiYxC9QKFNiZc5xyNok=";
  };

  propagatedBuildInputs = [ qtbase ];
}
