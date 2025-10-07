{
  qtModule,
  fetchFromGitHub,
  qtbase,
}:

qtModule rec {
  pname = "qtmqtt";
  version = "6.9.3";

  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtmqtt";
    tag = "v${version}";
    hash = "sha256-xzh2cNPlGe0VlCdNN1u8vBi+Uq+U2oa2bskAJQTt0ik=";
  };

  propagatedBuildInputs = [ qtbase ];
}
