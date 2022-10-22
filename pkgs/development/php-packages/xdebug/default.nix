{ buildPecl, lib }:

buildPecl {
  pname = "xdebug";

  version = "3.1.5";
  sha256 = "sha256-VfbvOBJF2gebL8XOHPvLeWEZfQwOBPnZd2E8+aqWmnk=";

  doCheck = true;
  checkTarget = "test";

  zendExtension = true;

  meta = with lib; {
    description = "Provides functions for function traces and profiling";
    license = licenses.php301;
    homepage = "https://xdebug.org/";
    maintainers = teams.php.members;
  };
}
