{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "0.8.4";
  name = "liburcu-${version}";

  src = fetchurl {
    url = "http://lttng.org/files/urcu/userspace-rcu-${version}.tar.bz2";
    sha256 = "04py48xphylb246mpkzvld0yprj5h7cyv6pydr8b25aax5bs3h4n";
  };

  meta = with stdenv.lib; {
    description = "Userspace RCU (read-copy-update) library";
    homepage = http://lttng.org/urcu;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };

}
