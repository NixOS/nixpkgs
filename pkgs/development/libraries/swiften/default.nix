{ stdenv, python, fetchurl, openssl, boost, sconsPackages }:
stdenv.mkDerivation rec {
  pname = "swiften";
  version = "4.0.2";

  nativeBuildInputs = [ sconsPackages.scons_3_1_2 ];
  buildInputs           = [ python ];
  propagatedBuildInputs = [ openssl boost ];

  src = fetchurl {
    url    = "https://swift.im/downloads/releases/swift-${version}/swift-${version}.tar.gz";
    sha256 = "0w0aiszjd58ynxpacwcgf052zpmbpcym4dhci64vbfgch6wryz0w";
  };

  patches = [ ./scons.patch ./build-fix.patch ];

  sconsFlags = [
    "openssl=${openssl.dev}"
    "boost_includedir=${boost.dev}/include"
    "boost_libdir=${boost.out}/lib"
    "boost_bundled_enable=false"
    "max_jobs=1"
    "optimize=1"
    "debug=0"
    "swiften_dll=1"
  ];
  preInstall = ''
    installTargets="$out"
    installFlags+=" SWIFTEN_INSTALLDIR=$out"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "An XMPP library for C++, used by the Swift client";
    homepage    = "http://swift.im/swiften.html";
    license     = licenses.gpl2Plus;
    platforms   = platforms.linux;
    maintainers = [ maintainers.twey ];
  };
}
