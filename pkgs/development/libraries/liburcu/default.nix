{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "0.8.6";
  name = "liburcu-${version}";

  src = fetchurl {
    url = "http://lttng.org/files/urcu/userspace-rcu-${version}.tar.bz2";
    sha256 = "08dbfkdj4pm9s3q56nwa1vzldkf1jav61g2r4xq7mfhlw2yd79di";
  };

  meta = with stdenv.lib; {
    description = "Userspace RCU (read-copy-update) library";
    homepage = http://lttng.org/urcu;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };

}
