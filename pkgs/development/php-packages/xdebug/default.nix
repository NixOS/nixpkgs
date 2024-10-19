{
  buildPecl,
  lib,
  fetchFromGitHub,
}:

let
  version = "3.3.2";
in
buildPecl {
  inherit version;

  pname = "xdebug";

  src = fetchFromGitHub {
    owner = "xdebug";
    repo = "xdebug";
    rev = version;
    hash = "sha256-3Hj/6pFLwJkVfsUIkX9lP8cOa1cVjobqHZd/cnH0TaU=";
  };

  doCheck = true;

  zendExtension = true;

  meta = {
    changelog = "https://github.com/xdebug/xdebug/releases/tag/${version}";
    description = "Provides functions for function traces and profiling";
    homepage = "https://xdebug.org/";
    license = lib.licenses.php301;
    maintainers = lib.teams.php.members;
  };
}
