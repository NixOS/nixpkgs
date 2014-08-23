{ stdenv, fetchurl }:

stdenv.mkDerivation  rec {
  name = "mxml-${version}";
  version = "2.8";

  src = fetchurl {
    url = "http://www.msweet.org/files/project3/${name}.tar.gz";
    sha256 = "1m8i62dfmgfc1v8y3zx0r4i2hr5n86yw01xh5kiq53bi3bwnk4qc";
  };

  meta = with stdenv.lib; {
    description = "a small XML library";
    homepage = http://www.minixml.org;
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
