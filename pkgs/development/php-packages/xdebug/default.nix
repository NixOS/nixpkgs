{
  buildPecl,
  lib,
  fetchFromGitHub,
}:

let
  version = "3.4.7";
in
buildPecl {
  inherit version;

  pname = "xdebug";

  src = fetchFromGitHub {
    owner = "xdebug";
    repo = "xdebug";
    rev = version;
    hash = "sha256-TxwEyXyUGq3rUWyLExyDopJZ29eAoh9QG1TC2+hImmc=";
  };

  doCheck = true;

  zendExtension = true;

  meta = {
    changelog = "https://github.com/xdebug/xdebug/releases/tag/${version}";
    description = "Provides functions for function traces and profiling";
    homepage = "https://xdebug.org/";
    license = lib.licenses.php301;
    teams = [ lib.teams.php ];
  };
}
