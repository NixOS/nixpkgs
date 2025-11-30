{
  buildPecl,
  lib,
  php,
  fetchFromGitHub,
}:

let
  version = "6.3.0";
in
buildPecl {
  inherit version;
  pname = "redis";

  src = fetchFromGitHub {
    repo = "phpredis";
    owner = "phpredis";
    rev = version;
    hash = "sha256-mdphyUG4OUc1PBEA5Ub1X9afFDMJ5+HoXH4WnmeAKpE=";
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
