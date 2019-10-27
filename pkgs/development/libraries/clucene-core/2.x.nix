{stdenv, fetchurl, cmake, boost, zlib}:

stdenv.mkDerivation rec {
  name = "clucene-core-2.3.3.4";

  src = fetchurl {
    url = "mirror://sourceforge/clucene/${name}.tar.gz";
    sha256 = "1arffdwivig88kkx685pldr784njm0249k0rb1f1plwavlrw9zfx";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost zlib ];

  cmakeFlags = [
    "-DBUILD_CONTRIBS=ON"
    "-DBUILD_CONTRIBS_LIB=ON"
    "-DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON"
  ] ++ stdenv.lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "-D_CL_HAVE_GCC_ATOMIC_FUNCTIONS=0"
    "-D_CL_HAVE_NAMESPACES_EXITCODE=0"
    "-D_CL_HAVE_NO_SNPRINTF_BUG_EXITCODE=0"
    "-D_CL_HAVE_NO_SNWPRINTF_BUG_EXITCODE=0"
    "-D_CL_HAVE_TRY_BLOCKS_EXITCODE=0"
    "-D_CL_HAVE_PTHREAD_MUTEX_RECURSIVE=0"
    "-DLUCENE_STATIC_CONSTANT_SYNTAX_EXITCODE=0"
  ];

  patches = # From debian
    [ ./Fix-pkgconfig-file-by-adding-clucene-shared-library.patch
      ./Fixing_ZLIB_configuration_in_shared_CMakeLists.patch
      ./Install-contribs-lib.patch
    ] ++ stdenv.lib.optionals stdenv.isDarwin [ ./fix-darwin.patch ];

  # fails with "Unable to find executable:
  # /build/clucene-core-2.3.3.4/build/bin/cl_test"
  doCheck = false;

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.cc.isClang "-Wno-error=c++11-narrowing";

  meta = with stdenv.lib; {
    description = "Core library for full-featured text search engine";
    longDescription = ''
      CLucene is a high-performance, scalable, cross platform, full-featured,
      open-source indexing and searching API. Specifically, CLucene is the guts
      of a search engine, the hard stuff. You write the easy stuff: the UI and
      the process of selecting and parsing your data files to pump them into
      the search engine yourself, and any specialized queries to pull it back
      for display or further processing.

      CLucene is a port of the very popular Java Lucene text search engine API.
    '';
    homepage = http://clucene.sourceforge.net;
    platforms = platforms.unix;
    license = with licenses; [ asl20 lgpl2 ];
  };
}
