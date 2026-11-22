{
  qtModule,
  fetchFromGitHub,
  qtbase,
}:

qtModule rec {
  pname = "qtmqtt";
  version = "6.12.0";

  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtmqtt";
    tag = "v${version}";
    hash = "sha256-jbcw43rCgCMU234Y+Dn7R/Qgz8cZRLz93L4heBtV408=";
  };

  propagatedBuildInputs = [ qtbase ];
}
