{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libstatgrab-0.91";

  src = fetchurl {
    url = "http://ftp.i-scream.org/pub/i-scream/libstatgrab/${name}.tar.gz";
    sha256 = "1azinx2yzs442ycwq6p15skl3mscmqj7fd5hq7fckhjp92735s83";
  };

  meta = with stdenv.lib; {
    homepage = http://www.i-scream.org/libstatgrab/;
    description = "A library that provides cross platforms access to statistics about the running system";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
