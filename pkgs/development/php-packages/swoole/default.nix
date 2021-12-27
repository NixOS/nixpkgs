{ lib, stdenv, buildPecl, php, valgrind, pcre2 }:

buildPecl {
  pname = "swoole";

  version = "4.8.4";
  sha256 = "sha256-gqDXcbjnsmo2XdrrRPeRrAD1yXtLkY8fZtu9OaiDq6s=";

  buildInputs = [ pcre2 ] ++ lib.optionals (!stdenv.isDarwin) [ valgrind ];
  internalDeps = lib.optionals (lib.versionOlder php.version "7.4") [ php.extensions.hash ];

  doCheck = true;
  checkTarget = "tests";

  meta = with lib; {
    description = "Coroutine-based concurrency library for PHP";
    license = licenses.asl20;
    homepage = "https://www.swoole.co.uk/";
    maintainers = teams.php.members;
  };
}
