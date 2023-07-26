{ qtModule
, fetchFromGitHub
, qtbase
}:

qtModule rec {
  pname = "qtmqtt";
  version = "6.5.2";
  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtmqtt";
    rev = "v${version}";
    hash = "sha256-yyerVzz+nGT5kjNo24zYqZcJmrE50KCp38s3+samjd0=";
  };
  qtInputs = [ qtbase ];
}
