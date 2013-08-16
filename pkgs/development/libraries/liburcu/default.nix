{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "0.7.7";
  name = "liburcu-${version}";

  src = fetchurl {
    url = "http://lttng.org/files/urcu/userspace-rcu-${version}.tar.bz2";
    sha256 = "1yxxnhrsy6sv6bmp7j96jjynnqns01zjgj94mk70jz54zvcagf4a";
  };

  meta = with stdenv.lib; {
    description = "Userspace RCU (read-copy-update) library";
    homepage = http://lttng.org/urcu;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };

}
