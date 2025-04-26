{
  buildPecl,
  lib,
  php,
  fetchFromGitHub,
}:

let
  version = "6.2.0";
in
buildPecl {
  inherit version;
  pname = "redis";

  src = fetchFromGitHub {
    repo = "phpredis";
    owner = "phpredis";
    rev = version;
    hash = "sha256-uUnH+AS4PgIm+uias5T5+W7X5Pzq4hx4c6zAl4OYk1g=";
  };

  internalDeps = with php.extensions; [ session ];

  meta = with lib; {
    changelog = "https://github.com/phpredis/phpredis/releases/tag/${version}";
    description = "PHP extension for interfacing with Redis";
    license = licenses.php301;
    homepage = "https://github.com/phpredis/phpredis/";
    teams = [ teams.php ];
  };
}
