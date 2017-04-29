{ stdenv, fetchurl, cmake, shared ? false }:

stdenv.mkDerivation rec {
  name = "pugixml-${version}";
  version = "1.8.1";

  src = fetchurl {
    url = "https://github.com/zeux/pugixml/releases/download/v${version}/${name}.tar.gz";
    sha256 = "0fcgggry5x5bn0zhb09ij9hb0p45nb0sv0d9fw3cm1cf62hp9n80";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=${if shared then "ON" else "OFF"}" ];

  preConfigure = ''
    # Enable long long support (required for filezilla)
    sed -ire '/PUGIXML_HAS_LONG_LONG/ s/^\/\///' src/pugiconfig.hpp
  '';

  meta = with stdenv.lib; {
    description = "Light-weight, simple and fast XML parser for C++ with XPath support";
    homepage = http://pugixml.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.unix;
  };
}
