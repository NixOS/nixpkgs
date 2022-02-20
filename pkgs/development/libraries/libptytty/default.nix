{ stdenv
, lib
, fetchurl
, cmake
}:

stdenv.mkDerivation rec {
  pname = "libptytty";
  version = "2.0";

  src = fetchurl {
    url = "http://dist.schmorp.de/libptytty/${pname}-${version}.tar.gz";
    sha256 = "1xrikmrsdkxhdy9ggc0ci6kg5b1hn3bz44ag1mk5k1zjmlxfscw0";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "OS independent and secure pty/tty and utmp/wtmp/lastlog";
    homepage = "http://dist.schmorp.de/libptytty";
    maintainers = with maintainers; [ rnhmjoj ];
    platforms = platforms.unix;
    license = licenses.gpl2;
  };

}
