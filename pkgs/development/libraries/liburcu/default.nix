{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "0.8.1";
  name = "liburcu-${version}";

  src = fetchurl {
    url = "http://lttng.org/files/urcu/userspace-rcu-${version}.tar.bz2";
    sha256 = "07p0lh43j7i1606m4l1dxm195z6fcfz74fmx7q2d7mrhn2bzc240";
  };

  meta = with stdenv.lib; {
    description = "Userspace RCU (read-copy-update) library";
    homepage = http://lttng.org/urcu;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };

}
