{
  qtModule,
  fetchFromGitHub,
  qtbase,
}:

qtModule rec {
  pname = "qtmqtt";
  version = "6.10.1";

  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtmqtt";
    tag = "v${version}";
    hash = "sha256-ve9fyhUZFI6TAr/SFRXJudA1yTmTlg8+Fgyc9OUv3ds=";
  };

  propagatedBuildInputs = [ qtbase ];
}
