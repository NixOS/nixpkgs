{ lib, stdenv, buildPecl, php, valgrind, pcre2 }:
let
  pname = "openswoole";
  version = "4.11.1";
in
buildPecl {
  inherit pname version;

  sha256 = "sha256-Rhoa4ny86dwB3e86/1W30AlDGRUDYjK8RusquKF5Izg=";

  buildInputs = [ pcre2 ] ++ lib.optionals (!stdenv.isDarwin) [ valgrind ];
  internalDeps = lib.optionals (lib.versionOlder php.version "7.4") [ php.extensions.hash ];

  meta = with lib; {
    changelog = "https://pecl.php.net/package/openswoole/${version}";
    description = "Coroutine-based concurrency library and high performance programmatic server for PHP";
    homepage = "https://www.openswoole.com/";
    license = licenses.asl20;
    longDescription = "Open Swoole allows you to build high-performance, async multi-tasking webservices and applications using an easy to use Coroutine API.\nOpen Swoole is a complete async solution that has built-in support for async programming via coroutines.\nIt offers a range of multi-threaded I/O modules (HTTP Server, WebSockets, TaskWorkers, Process Pools) out of the box and support for popular PHP clients like PDO for MySQL, and CURL.\nYou can use the sync or async, Coroutine API to write whole applications or create thousands of light weight Coroutines within one Linux process.";
    maintainers = teams.php.members;
  };
}
