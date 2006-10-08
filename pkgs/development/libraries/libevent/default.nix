{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libevent-1.1b";

  src = fetchurl {
    url = http://monkey.org/~provos/libevent-1.1b.tar.gz;
    md5 = "ec8dac612aa43ed172f300f396fcec49";
  };
}
