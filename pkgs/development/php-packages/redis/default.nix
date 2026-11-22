{
  buildPecl,
  lib,
  php,
  fetchFromGitHub,
}:

buildPecl (finalAttrs: {
  pname = "redis";
  version = "6.3.0";

  src = fetchFromGitHub {
    repo = "phpredis";
    owner = "phpredis";
    tag = finalAttrs.version;
    hash = "sha256-mdphyUG4OUc1PBEA5Ub1X9afFDMJ5+HoXH4WnmeAKpE=";
  };

  internalDeps = with php.extensions; [ session ];

  meta = {
    broken = lib.versionAtLeast php.version "8.6";
    changelog = "https://github.com/phpredis/phpredis/releases/tag/${finalAttrs.version}";
    description = "PHP extension for interfacing with Redis";
    license = lib.licenses.php301;
    homepage = "https://github.com/phpredis/phpredis/";
    teams = [ lib.teams.php ];
  };
})
