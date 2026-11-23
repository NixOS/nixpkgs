{
  qtModule,
  fetchFromGitHub,
  qtbase,
}:

qtModule rec {
  pname = "qtmqtt";
  version = "6.12.1";

  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtmqtt";
    tag = "v${version}";
    hash = "sha256-e0gQYuo+MmQnp1TWVZkBozMB0du592owM76OoG9QjZo=";
  };

  propagatedBuildInputs = [ qtbase ];
}
