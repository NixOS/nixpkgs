{ buildPecl, lib, php }:

buildPecl {
  pname = "redis";

  version = "5.3.7";
  sha256 = "sha256-uVgWbM2k9AvRfGmY+eIjkCGuZERnzYrVwV3vQgqtZbA=";

  internalDeps = with php.extensions; [
    session
  ];

  meta = with lib; {
    description = "PHP extension for interfacing with Redis";
    license = licenses.php301;
    homepage = "https://github.com/phpredis/phpredis/";
    maintainers = teams.php.members;
  };
}
