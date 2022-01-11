/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivial-backtrace";
  version = "20200610-git";

  description = "trivial-backtrace";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivial-backtrace/2020-06-10/trivial-backtrace-20200610-git.tgz";
    sha256 = "0slz2chal6vpiqx9zmjh4cnihhw794rq3267s7kz7livpiv52rks";
  };

  packageName = "trivial-backtrace";

  asdFilesToKeep = ["trivial-backtrace.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-backtrace DESCRIPTION trivial-backtrace SHA256
    0slz2chal6vpiqx9zmjh4cnihhw794rq3267s7kz7livpiv52rks URL
    http://beta.quicklisp.org/archive/trivial-backtrace/2020-06-10/trivial-backtrace-20200610-git.tgz
    MD5 1d9a7cc7c5840e4eba84c89648908525 NAME trivial-backtrace FILENAME
    trivial-backtrace DEPS NIL DEPENDENCIES NIL VERSION 20200610-git SIBLINGS
    (trivial-backtrace-test) PARASITES NIL) */
