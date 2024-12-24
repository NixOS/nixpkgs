{
  buildPecl,
  lib,
  fetchFromGitHub,
}:

let
  version = "3.4.0";
in
buildPecl {
  inherit version;

  pname = "xdebug";

  src = fetchFromGitHub {
    owner = "xdebug";
    repo = "xdebug";
    rev = version;
    hash = "sha256-Gt6/ARrUzmsAhsdkKPNiX0CBmWTv7D3mHnxvvWjbLnE=";
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
