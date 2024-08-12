{
  buildPecl,
  lib,
  fetchFromGitHub,
}:

let
  version = "3.4.0alpha1";
in
buildPecl {
  inherit version;

  pname = "xdebug";

  src = fetchFromGitHub {
    owner = "xdebug";
    repo = "xdebug";
    rev = version;
    hash = "sha256-rV+1nwygtGFwp+OTedwTDc9JMlS4rESgMk3MLblFOZM=";
  };

  doCheck = true;
  checkTarget = "test";

  zendExtension = true;

  meta = {
    changelog = "https://github.com/xdebug/xdebug/releases/tag/${version}";
    description = "Provides functions for function traces and profiling";
    homepage = "https://xdebug.org/";
    license = lib.licenses.php301;
    maintainers = lib.teams.php.members;
  };
}
