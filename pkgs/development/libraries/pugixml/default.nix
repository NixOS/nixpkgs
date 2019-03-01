{ stdenv, fetchurl, cmake, shared ? false }:

stdenv.mkDerivation rec {
  name = "pugixml-${version}";
  version = "1.9";

  src = fetchurl {
    url = "https://github.com/zeux/pugixml/releases/download/v${version}/${name}.tar.gz";
    sha256 = "19nv3zhik3djp4blc4vrjwrl8dfhzmal8b21sq7y907nhddx6mni";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=${if shared then "ON" else "OFF"} -DBUILD_PKGCONFIG=ON" ];

  preConfigure = ''
    # Enable long long support (required for filezilla)
    sed -ire '/PUGIXML_HAS_LONG_LONG/ s/^\/\///' src/pugiconfig.hpp
  '';

  meta = with stdenv.lib; {
    description = "Light-weight, simple and fast XML parser for C++ with XPath support";
    homepage = https://pugixml.org;
    license = licenses.mit;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.unix;
  };
}
