{
  buildPecl,
  lib,
  libuuid,
  fetchFromGitHub,
}:

let
  version = "v1.2.1";
in
buildPecl {
  inherit version;
  pname = "uuid";

  src = fetchFromGitHub {
    owner = "php";
    repo = "pecl-networking-uuid";
    rev = "refs/tags/${version}";
    hash = "sha256-C4SoSKkCTQOLKM1h47vbBgiHTG+ChocDB9tzhWfKUsw=";
  };

  buildInputs = [ libuuid ];
  makeFlags = [ "phpincludedir=$(dev)/include" ];
  doCheck = true;

  env.PHP_UUID_DIR = libuuid;

  meta = {
    changelog = "https://github.com/php/pecl-networking-uuid/releases/tag/${version}";
    description = "A wrapper around Universally Unique IDentifier library (libuuid).";
    license = lib.licenses.php301;
    homepage = "https://github.com/php/pecl-networking-uuid";
    maintainers = lib.teams.php.members;
    platforms = lib.platforms.linux;
  };
}
