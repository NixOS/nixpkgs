{
  qtModule,
  fetchFromGitHub,
  qtbase,
}:

qtModule rec {
  pname = "qtmqtt";
  version = "6.8.1";

  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtmqtt";
    rev = "v${version}";
    hash = "sha256-PmIs+06DjPTbVTNfnl4N/F6sL7qa/X58AvbyCxltAMw=";
  };

  propagatedBuildInputs = [ qtbase ];
}
