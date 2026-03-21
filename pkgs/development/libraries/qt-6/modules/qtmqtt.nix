{
  qtModule,
  fetchFromGitHub,
  qtbase,
}:

qtModule rec {
  pname = "qtmqtt";
  version = "6.10.2";

  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtmqtt";
    tag = "v${version}";
    hash = "sha256-NjYvL6BCn0UP7F2CW81upzZ8EwFAkhoUa5cdaH0uhM4=";
  };

  propagatedBuildInputs = [ qtbase ];
}
