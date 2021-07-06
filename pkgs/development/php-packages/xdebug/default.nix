{ buildPecl, lib }:

buildPecl {
  pname = "xdebug";

  version = "3.0.4";
  sha256 = "1bvjmnx9bcfq4ikp02kiqg0f7ccgx4mkmz5d7g6v0d263x4r0wmj";

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
