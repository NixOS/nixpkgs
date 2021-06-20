{ buildPecl, lib }:

buildPecl {
  pname = "xdebug";

  version = "3.0.3";
  sha256 = "sha256-5yZagVGOOX+XLcki50bRpIRTcXf/SJVDUWfRCeKTJDI=";

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
