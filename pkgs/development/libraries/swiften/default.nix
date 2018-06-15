{ stdenv, python, fetchurl, openssl, boost }:
stdenv.mkDerivation rec {
  name    = "swiften-${version}";
  version = "4.0";

  buildInputs           = [ python ];
  propagatedBuildInputs = [ openssl boost ];

  src = fetchurl {
    url    = "http://swift.im/downloads/releases/swift-${version}/swift-${version}.tar.gz";
    sha256 = "06bk45hxqmny8z7x78ycrfrazq6xdzv5c28i8x0lgc85j03b5dsh";
  };
  
  buildPhase = ''
    patchShebangs ./scons
    ./scons openssl=${openssl.dev} \
            boost_includedir=${boost.dev}/include \
            boost_libdir=${boost.out}/lib \
            boost_bundled_enable=false \
            SWIFTEN_INSTALLDIR=$out $out
  '';
  installPhase = "true";

  meta = with stdenv.lib; {
    description = "An XMPP library for C++, used by the Swift client";
    homepage    = http://swift.im/swiften.html;
    license     = licenses.gpl2Plus;
    platforms   = platforms.linux;
    maintainers = [ maintainers.twey ];
  };
}
