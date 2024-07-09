{ stdenv
, lib
, libidn
, lua
, miniupnpc
, expat
, zlib
, fetchurl
, fetchpatch
, openssl
, boost
, scons
}:

stdenv.mkDerivation rec {
  pname = "swiften";
  version = "4.0.3";

  src = fetchurl {
    url = "http://swift.im/git/swift/snapshot/swift-${version}.tar.bz2";
    hash = "sha256-aj+T6AevtR8birbsj+83nfzFC6cf72q+7nwSM0jaZrA=";
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
    scons
  ];

  buildInputs = [
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

    find . \( \
      -name '*.py' -o -name SConscript -o -name SConstruct \
      \) -exec 2to3 -w {} +
  '';

  installTargets = "${placeholder "out"}";

  installFlags = [
    "SWIFTEN_INSTALLDIR=${placeholder "out"}"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "XMPP library for C++, used by the Swift client";
    mainProgram = "swiften-config";
    homepage = "http://swift.im/swiften.html";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.twey ];
  };
}
