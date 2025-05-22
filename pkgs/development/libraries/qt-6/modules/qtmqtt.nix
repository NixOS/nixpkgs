{
  qtModule,
  fetchFromGitHub,
  qtbase,
}:

qtModule rec {
  pname = "qtmqtt";
  version = "6.9.0";

  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtmqtt";
    tag = "v${version}";
    hash = "sha256-kBm173AJYVjAH2ZH6xTMyqEcw0GB1XkbxKc3vYriMvU=";
  };

  propagatedBuildInputs = [ qtbase ];
}
