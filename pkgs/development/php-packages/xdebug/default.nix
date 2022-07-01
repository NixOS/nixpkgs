{ buildPecl, lib }:

buildPecl {
  pname = "xdebug";

  version = "3.1.4";
  sha256 = "sha256-QZWSb59sToAv90m7LKhaxQY2cZpy5TieNy4171I1Bfk=";

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
