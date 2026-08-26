{
  qtModule,
  fetchFromGitHub,
  qtbase,
}:

qtModule rec {
  pname = "qtmqtt";
  version = "6.11.2";

  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtmqtt";
    tag = "v${version}";
    hash = "sha256-Xg4vfVfYgruRXB6LSWFJWSMtsClJMtML+KhaQExWUGs=";
  };

  propagatedBuildInputs = [ qtbase ];
}
