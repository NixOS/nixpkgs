{
  buildPecl,
  lib,
  php,
}:

buildPecl {
  pname = "parallel";
  version = "1.2.15";
  hash = "sha256-J8Syykv6Z+/r6EVBrE0lVHunW2AxOcjw4TZ4DQgPuSQ=";
  meta = {
    description = "Parallel concurrency API";
    # parallel extension requires PHP with ZTS enabled
    # we mark extension as broken if ZTS support isn't enabled
    broken = !php.ztsSupport;
    homepage = "https://pecl.php.net/package/parallel";
    license = lib.licenses.php301;
    teams = [ lib.teams.php ];
  };
}
