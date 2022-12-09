{ buildPecl, lib }:

buildPecl {
  pname = "xdebug";

  version = "3.2.0";
  sha256 = "1drj00z8ididm2iw7a7pnrsvakrr1g0i49aqkyz5zpysxh7b4sbp";

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
