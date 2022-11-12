{ buildPecl, lib }:

buildPecl {
  pname = "xdebug";

  version = "3.1.6";
  sha256 = "1lnmrb5kgq8lbhjs48j3wwhqgk44pnqb1yjq4b5r6ysv9l5wlkjm";

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
