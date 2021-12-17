{ lib, stdenv, buildPecl, php, valgrind, pcre2 }:

buildPecl {
  pname = "swoole";

  version = "4.8.3";
  sha256 = "sha256-Oa/SnmmMc/KZXyP/qX9BT7V1xPa4EWJa/GUNngpA4pw=";

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
