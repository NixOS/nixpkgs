{ buildPecl, lib }:

buildPecl {
  pname = "xdebug";

  version = "3.1.2";
  sha256 = "sha256-CD9r4RAN95zL3wSdr8OTC6s18OuA+bGawa2E+md5zPM=";

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
