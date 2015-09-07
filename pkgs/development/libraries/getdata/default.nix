{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "getdata-0.8.9";
  src = fetchurl {
    url = "mirror://sourceforge/getdata/${name}.tar.bz2";
    sha256 = "1cgwrflpp9ia2cwnhmwp45nmsg15ymjh03pysrfigyfmag94ac51";
  };

  meta = with stdenv.lib; {
    description = "Reference implementation of the Dirfile Standards";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.vbgl ];
    homepage = http://getdata.sourceforge.net/;
  };
}
