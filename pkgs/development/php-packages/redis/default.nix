{ buildPecl, lib, php }:

buildPecl {
  pname = "redis";

  version = "5.3.5";
  sha256 = "sha256-1V+lzGmRmJF7or3IJ9pjKtd/AJuiZC0nUEVql22+WYk=";

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
