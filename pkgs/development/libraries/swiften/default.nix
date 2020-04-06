{ stdenv, python, fetchurl, openssl, boost, scons }:
stdenv.mkDerivation rec {
  pname = "swiften";
  version = "4.0.2";

  nativeBuildInputs = [ scons.py2 ];
  buildInputs           = [ python ];
  propagatedBuildInputs = [ openssl boost ];

  src = fetchurl {
    url    = "https://swift.im/downloads/releases/swift-${version}/swift-${version}.tar.gz";
    sha256 = "0w0aiszjd58ynxpacwcgf052zpmbpcym4dhci64vbfgch6wryz0w";
  };

  patches = [ ./scons.patch ];

  sconsFlags = [
    "openssl=${openssl.dev}"
    "boost_includedir=${boost.dev}/include"
    "boost_libdir=${boost.out}/lib"
    "boost_bundled_enable=false"
  ];
  preInstall = ''
    installTargets="$out"
    installFlags+=" SWIFT_INSTALLDIR=$out"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "An XMPP library for C++, used by the Swift client";
    homepage    = http://swift.im/swiften.html;
    license     = licenses.gpl2Plus;
    platforms   = platforms.linux;
    maintainers = [ maintainers.twey ];
    broken = true; # Broken since 2019-11-20 (https://hydra.nixos.org/build/114681755)
  };
}
