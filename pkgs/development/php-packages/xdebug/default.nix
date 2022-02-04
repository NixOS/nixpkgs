{ buildPecl, lib }:

buildPecl {
  pname = "xdebug";

  version = "3.1.3";
  sha256 = "sha256-N9CmcBlV9bNAbGwye3cCvXwhRi5lbztMziSgUlgBPU4=";

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
