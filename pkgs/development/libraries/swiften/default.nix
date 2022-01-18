{ stdenv
, lib
, python2
, libidn
, lua
, miniupnpc
, expat
, zlib
, fetchurl
, fetchpatch
, openssl
, boost
, sconsPackages
}:

stdenv.mkDerivation rec {
  pname = "swiften";
  version = "4.0.2";

  src = fetchurl {
    url = "https://swift.im/downloads/releases/swift-${version}/swift-${version}.tar.gz";
    sha256 = "0w0aiszjd58ynxpacwcgf052zpmbpcym4dhci64vbfgch6wryz0w";
  };

  patches = [
    ./scons.patch
    ./build-fix.patch

    # Fix build with latest boost
    # https://swift.im/git/swift/commit/Swiften/Base/Platform.h?id=3666cbbe30e4d4e25401a5902ae359bc2c24248b
    (fetchpatch {
      name = "3666cbbe30e4d4e25401a5902ae359bc2c24248b.patch";
      url = "https://swift.im/git/swift/patch/Swiften/Base/Platform.h?id=3666cbbe30e4d4e25401a5902ae359bc2c24248b";
      sha256 = "Wh8Nnfm0/EppSJ7aH2vTNObHtodE5tM19kV1oDfm70w=";
    })
  ];

  nativeBuildInputs = [
    sconsPackages.scons_3_1_2
  ];

  buildInputs = [
    python2
    libidn
    lua
    miniupnpc
    expat
    zlib
  ];

  propagatedBuildInputs = [
    openssl
    boost
  ];

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

  postPatch = ''
    # Ensure bundled dependencies cannot be used.
    rm -rf 3rdParty
  '';

  installTargets = "${placeholder "out"}";

  installFlags = [
    "SWIFTEN_INSTALLDIR=${placeholder "out"}"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "An XMPP library for C++, used by the Swift client";
    homepage = "http://swift.im/swiften.html";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.twey ];
  };
}
