{ stdenv, fetchurl, boost, libwpd, libwpg, pkgconfig, zlib, gperf
, librevenge, libxml2, icu, perl, cppunit, doxygen
}:

stdenv.mkDerivation rec {
  name = "libvisio-${version}";
  version = "0.1.6";

  outputs = [ "out" "bin" "dev" "doc" ];

  src = fetchurl {
    url = "https://dev-www.libreoffice.org/src/libvisio/${name}.tar.xz";
    sha256 = "1yahpfl13qk6178irv8jn5ppxdn7isafqisyqsdw0lqxcz9h447y";
  };

  nativeBuildInputs = [ pkgconfig cppunit doxygen ];
  buildInputs = [ boost libwpd libwpg zlib gperf librevenge libxml2 icu perl ];

  configureFlags = [
    "--disable-werror"
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A library providing ability to interpret and import visio diagrams into various applications";
    homepage = https://wiki.documentfoundation.org/DLP/Libraries/libvisio;
    license = licenses.mpl20;
    platforms = platforms.unix;
  };
}
