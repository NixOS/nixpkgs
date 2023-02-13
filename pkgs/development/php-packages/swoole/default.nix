{ lib, stdenv, buildPecl, php, valgrind, pcre2, fetchFromGitHub }:

let
  version = "5.0.1";
in buildPecl {
  inherit version;
  pname = "swoole";

  src = fetchFromGitHub {
    owner = "swoole";
    repo = "swoole-src";
    rev = "v${version}";
    sha256 = "sha256-d0xccbfOmebWR14oTUviWz/mB5IA7iXn0uUWxTQRd9w=";
  };

  buildInputs = [ pcre2 ] ++ lib.optionals (!stdenv.isDarwin) [ valgrind ];

  doCheck = true;
  checkTarget = "tests";

  meta = with lib; {
    changelog = "https://github.com/swoole/swoole-src/releases/tag/v${version}";
    description = "Coroutine-based concurrency library for PHP";
    license = licenses.asl20;
    homepage = "https://www.swoole.co.uk/";
    maintainers = teams.php.members;
  };
}
