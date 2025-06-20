{
  qtModule,
  fetchFromGitHub,
  qtbase,
}:

qtModule rec {
  pname = "qtmqtt";
  version = "6.9.1";

  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtmqtt";
    tag = "v${version}";
    hash = "sha256-nyMsl07pL6mNpg1p7W3cn2NXGmEbm+y9tgMexp6+xYI=";
  };

  propagatedBuildInputs = [ qtbase ];
}
