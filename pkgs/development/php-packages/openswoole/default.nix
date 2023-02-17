{ lib, stdenv, buildPecl, php, valgrind, pcre2, fetchFromGitHub }:

let
  pname = "openswoole";
  version = "22.0.0";
in buildPecl {
  inherit version;
  pname = "openswoole";

  src = fetchFromGitHub {
    owner = "openswoole";
    repo = "swoole-src";
    rev = "v${version}";
    sha256 = "sha256-4Z7mBNGHXS/giSCmPpSyu9/99MEjCnoXgymDM/s1gk8=";
  };

  buildInputs = [ pcre2 ] ++ lib.optionals (!stdenv.isDarwin) [ valgrind ];

  meta = with lib; {
    changelog = "https://github.com/openswoole/swoole-src/releases/tag/v${version}";
    description = "Coroutine-based concurrency library and high performance programmatic server for PHP";
    homepage = "https://www.openswoole.com/";
    license = licenses.asl20;
    longDescription = ''
      Open Swoole allows you to build high-performance, async multi-tasking webservices and applications using an easy to use Coroutine API.\nOpen Swoole is a complete async solution that has built-in support for async programming via coroutines.
      It offers a range of multi-threaded I/O modules (HTTP Server, WebSockets, TaskWorkers, Process Pools) out of the box and support for popular PHP clients like PDO for MySQL, and CURL.
      You can use the sync or async, Coroutine API to write whole applications or create thousands of light weight Coroutines within one Linux process.
    '';
    maintainers = teams.php.members;
  };
}
