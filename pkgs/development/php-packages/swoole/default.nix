{ lib, buildPecl, php, valgrind, pcre' }:

buildPecl {
  pname = "swoole";

  version = "4.6.4";
  sha256 = "0hgndnn27q7fbsb0nw6bfdg0kyy5di9vrmf7g53jc6lsnf73ha31";

  buildInputs = [ valgrind pcre' ];
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
