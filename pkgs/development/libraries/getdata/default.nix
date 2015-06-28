{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "getdata-0.8.8";
  src = fetchurl {
    url = "mirror://sourceforge/getdata/${name}.tar.bz2";
    sha256 = "1p5sncbr0bjrx1ki57di0j9rl5ksv0hbfy7bkcb4vaz9z9mrn8xj";
  };

  meta = with stdenv.lib; {
    description = "Reference implementation of the Dirfile Standards";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.vbgl ];
    homepage = http://getdata.sourceforge.net/;
  };
}
