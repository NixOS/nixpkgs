{ qtModule
, fetchFromGitHub
, qtbase
}:

qtModule rec {
  pname = "qtmqtt";
  version = "6.7.2";

  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtmqtt";
    rev = "v${version}";
    hash = "sha256-5OvU8I7hSnbBbu8OTrd0o2KSOyIMVfGGUSy4IsA85fA=";
  };

  propagatedBuildInputs = [ qtbase ];
}
