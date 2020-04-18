args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-backtrace'';
  version = ''20190710-git'';

  description = ''trivial-backtrace'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-backtrace/2019-07-10/trivial-backtrace-20190710-git.tgz'';
    sha256 = ''01pzn5ki3w5sgp270rqg6y982zw4p72x5zqcdjgn8hp7lk2a9g9x'';
  };

  packageName = "trivial-backtrace";

  asdFilesToKeep = ["trivial-backtrace.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-backtrace DESCRIPTION trivial-backtrace SHA256
    01pzn5ki3w5sgp270rqg6y982zw4p72x5zqcdjgn8hp7lk2a9g9x URL
    http://beta.quicklisp.org/archive/trivial-backtrace/2019-07-10/trivial-backtrace-20190710-git.tgz
    MD5 e9035ed00321b24278cbf5449a1aebed NAME trivial-backtrace FILENAME
    trivial-backtrace DEPS NIL DEPENDENCIES NIL VERSION 20190710-git SIBLINGS
    (trivial-backtrace-test) PARASITES NIL) */
