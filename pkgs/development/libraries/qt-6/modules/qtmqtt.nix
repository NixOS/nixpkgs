{ qtModule
, fetchFromGitHub
, qtbase
}:

qtModule rec {
  pname = "qtmqtt";
  version = "6.7.0";

  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtmqtt";
    rev = "v${version}";
    hash = "sha256-LUYb4Wb1fLUwIvDOsVU/iSOyx9pcfPrmiFnQskbT2d8=";
  };

  propagatedBuildInputs = [ qtbase ];
}
