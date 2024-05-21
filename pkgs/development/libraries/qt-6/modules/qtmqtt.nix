{ qtModule
, fetchFromGitHub
, qtbase
}:

qtModule rec {
  pname = "qtmqtt";
  version = "6.7.1";

  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtmqtt";
    rev = "v${version}";
    hash = "sha256-Dl+ZJjQU0vHurnhRVMYh0ry74iXb27Zld5dT21AxVhI=";
  };

  propagatedBuildInputs = [ qtbase ];
}
