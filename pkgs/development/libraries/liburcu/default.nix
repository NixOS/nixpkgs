{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "0.9.1";
  name = "liburcu-${version}";

  src = fetchurl {
    url = "http://lttng.org/files/urcu/userspace-rcu-${version}.tar.bz2";
    sha256 = "05c7znx1dfaqwf7klw8h02y3cjaqzg1w8kwmpb4rgv2vv7lpilpq";
  };

  meta = with stdenv.lib; {
    description = "Userspace RCU (read-copy-update) library";
    homepage = http://lttng.org/urcu;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };

}
