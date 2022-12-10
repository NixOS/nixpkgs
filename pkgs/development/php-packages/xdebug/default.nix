{ buildPecl, lib, php }:

let
  versionData = if (lib.versionOlder php.version "8.1") then {
    version = "3.1.6";
    sha256 = "1lnmrb5kgq8lbhjs48j3wwhqgk44pnqb1yjq4b5r6ysv9l5wlkjm";
  } else {
    version = "3.2.0";
    sha256 = "1drj00z8ididm2iw7a7pnrsvakrr1g0i49aqkyz5zpysxh7b4sbp";
  };
in
buildPecl {
  pname = "xdebug";

  inherit (versionData) version sha256;

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
