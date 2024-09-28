{ qtModule
, fetchFromGitHub
, qtbase
}:

qtModule rec {
  pname = "qtmqtt";
  version = "6.7.3";

  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtmqtt";
    rev = "v${version}";
    hash = "sha256-QVLt1nhxYIMmmVY1rZ8pnkXNs0N6hp1o8rv33o8ptxM=";
  };

  propagatedBuildInputs = [ qtbase ];
}
