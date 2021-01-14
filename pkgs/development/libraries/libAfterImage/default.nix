{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation {
  pname = "libAfterImage";
  version = "1.20";

  src = fetchurl {
    name = "libAfterImage-1.20.tar.bz2";
    urls = [
      "https://sourceforge.net/projects/afterstep/files/libAfterImage/1.20/libAfterImage-1.20.tar.bz2/download"
      "ftp://ftp.afterstep.org/stable/libAfterImage/libAfterImage-1.20.tar.bz2"
    ];
    sha256 = "0n74rxidwig3yhr6fzxsk7y19n1nq1f296lzrvgj5pfiyi9k48vf";
  };

  buildInputs = [ zlib ];

  meta = with stdenv.lib; {
    homepage = "http://www.afterstep.org/afterimage/";
    description = "A generic image manipulation library";
    platforms = platforms.unix;
    maintainers = [ maintainers.veprbl ];
    license = licenses.lgpl21;
  };
}
