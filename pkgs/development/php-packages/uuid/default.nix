{
  buildPecl,
  lib,
  libuuid,
  fetchFromGitHub,
}:

let
  version = "1.3.0";
in
buildPecl {
  inherit version;
  pname = "uuid";

  src = fetchFromGitHub {
    owner = "php";
    repo = "pecl-networking-uuid";
    tag = "v${version}";
    hash = "sha256-00zJ//O1xqKTedRYThzeXOuL25wKLMZXjJWm/eXLkC4=";
  };

  buildInputs = [ libuuid ];
  makeFlags = [ "phpincludedir=$(dev)/include" ];
  doCheck = true;

  env.PHP_UUID_DIR = libuuid;

  meta = {
    changelog = "https://github.com/php/pecl-networking-uuid/releases/tag/v${version}";
    description = "Wrapper around Universally Unique IDentifier library (libuuid)";
    license = lib.licenses.php301;
    homepage = "https://github.com/php/pecl-networking-uuid";
    teams = [ lib.teams.php ];
    platforms = lib.platforms.linux;
  };
}
