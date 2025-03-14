{
  buildPecl,
  lib,
  php,
}:

buildPecl {
  pname = "parallel";
  version = "1.2.4";
  hash = "sha256-s9W9aZpQsJLdzZ/d2E1iGDsMTAAjeWbOgWeKP6nNp0A=";
  meta = {
    description = "Parallel concurrency API";
    # parallel extension requires PHP with ZTS enabled
    # we mark extension as broken if ZTS support isn't enabled
    broken = !php.ztsSupport;
    homepage = "https://pecl.php.net/package/parallel";
    license = lib.licenses.php301;
    maintainers = lib.teams.php.members;
  };
}
