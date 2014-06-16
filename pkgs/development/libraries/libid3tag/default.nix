{stdenv, fetchurl, zlib, gperf}:

stdenv.mkDerivation {
  name = "libid3tag-0.15.1b";
  src = fetchurl {
    url = mirror://sourceforge/mad/libid3tag-0.15.1b.tar.gz;
    sha256 = "63da4f6e7997278f8a3fef4c6a372d342f705051d1eeb6a46a86b03610e26151";
  };

  propagatedBuildInputs = [ zlib gperf ];

  patches = [ ./debian-patches.patch ];

  meta = with stdenv.lib; {
    description = "ID3 tag manipulation library";
    homepage = http://mad.sourceforge.net/;
    license = licenses.gpl2;
    maintainers = [ maintainers.fuuzetsu ];
  };
}
