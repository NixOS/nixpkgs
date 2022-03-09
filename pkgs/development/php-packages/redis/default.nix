{ buildPecl, lib, php }:

buildPecl {
  pname = "redis";

  version = "5.3.7";
  sha256 = "sha256-uVgWbM2k9AvRfGmY+eIjkCGuZERnzYrVwV3vQgqtZbA=";

  internalDeps = with php.extensions; [
    session
  ] ++ lib.optionals (lib.versionOlder php.version "8.0") [
    json
  ] ++ lib.optionals (lib.versionOlder php.version "7.4") [
    hash
  ];

  meta = with lib; {
    description = "PHP extension for interfacing with Redis";
    license = licenses.php301;
    homepage = "https://github.com/phpredis/phpredis/";
    maintainers = teams.php.members;
  };
}
