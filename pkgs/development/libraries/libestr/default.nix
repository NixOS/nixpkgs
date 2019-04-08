{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libestr-0.1.11";

  src = fetchurl {
    url = "http://libestr.adiscon.com/files/download/${name}.tar.gz";
    sha256 = "0910ifzcs8kpd3srrr4fvbacgh2zrc6yn7i4rwfj6jpzhlkjnqs6";
  };

  meta = with stdenv.lib; {
    homepage = http://libestr.adiscon.com/;
    description = "Some essentials for string handling";
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
