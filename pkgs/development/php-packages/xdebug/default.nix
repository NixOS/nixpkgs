{
  buildPecl,
  lib,
  fetchFromGitHub,
}:

let
  version = "3.4.2";
in
buildPecl {
  inherit version;

  pname = "xdebug";

  src = fetchFromGitHub {
    owner = "xdebug";
    repo = "xdebug";
    rev = version;
    hash = "sha256-LTM2c9DC837y0t4S3m9292x37q4tXg1Poh2dm0KAyJc=";
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
