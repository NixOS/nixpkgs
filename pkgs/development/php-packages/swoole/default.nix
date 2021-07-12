{ lib, buildPecl, php, valgrind, pcre2 }:

buildPecl {
  pname = "swoole";

  version = "4.6.7";
  sha256 = "107wp403z8skkqrcm240vyyy6wqx5a4v2bqhlshlknyi14r2v165";

  buildInputs = [ valgrind pcre2 ];
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
