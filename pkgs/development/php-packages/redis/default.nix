{
  buildPecl,
  lib,
  php,
  fetchFromGitHub,
}:

let
  version = "6.1.0";
in
buildPecl {
  inherit version;
  pname = "redis";

  src = fetchFromGitHub {
    repo = "phpredis";
    owner = "phpredis";
    rev = version;
    hash = "sha256-zuvdWBJl6vBDnIAR0txfar1+c06VqGnwtobZnxok2uU=";
  };

  internalDeps = with php.extensions; [ session ];

  meta = with lib; {
    changelog = "https://github.com/phpredis/phpredis/releases/tag/${version}";
    description = "PHP extension for interfacing with Redis";
    license = licenses.php301;
    homepage = "https://github.com/phpredis/phpredis/";
    maintainers = teams.php.members;
  };
}
