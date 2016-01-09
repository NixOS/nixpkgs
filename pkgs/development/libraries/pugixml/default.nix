{ stdenv, fetchurl, cmake, shared ? false }:

stdenv.mkDerivation rec {
  name = "pugixml-${version}";
  version = "1.7";

  src = fetchurl {
    url = "https://github.com/zeux/pugixml/releases/download/v${version}/${name}.tar.gz";
    sha256 = "1jpml475kbhs1aqwa48g2cbfxlrb9qp115m2j9yryxhxyr30vqgv";
  };

  nativeBuildInputs = [ cmake ];

  sourceRoot = "${name}/scripts";

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=${if shared then "ON" else "OFF"}" ];

  preConfigure = ''
    # Enable long long support (required for filezilla)
    sed -ire '/PUGIXML_HAS_LONG_LONG/ s/^\/\///' ../src/pugiconfig.hpp
  '';

  meta = with stdenv.lib; {
    description = "Light-weight, simple and fast XML parser for C++ with XPath support";
    homepage = http://pugixml.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
