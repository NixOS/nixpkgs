{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  cmake,
  boost,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "clucene-core";
  version = "2.3.3.4";

  src = fetchurl {
    url = "mirror://sourceforge/clucene/clucene-core-${version}.tar.gz";
    sha256 = "1arffdwivig88kkx685pldr784njm0249k0rb1f1plwavlrw9zfx";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    zlib
  ];

  cmakeFlags = [
    "-DBUILD_CONTRIBS=ON"
    "-DBUILD_CONTRIBS_LIB=ON"
    "-DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON"
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "-D_CL_HAVE_GCC_ATOMIC_FUNCTIONS=0"
    "-D_CL_HAVE_NAMESPACES_EXITCODE=0"
    "-D_CL_HAVE_NAMESPACES_EXITCODE__TRYRUN_OUTPUT="
    "-D_CL_HAVE_NO_SNPRINTF_BUG_EXITCODE=0"
    "-D_CL_HAVE_NO_SNPRINTF_BUG_EXITCODE__TRYRUN_OUTPUT="
    "-D_CL_HAVE_TRY_BLOCKS_EXITCODE=0"
    "-D_CL_HAVE_TRY_BLOCKS_EXITCODE__TRYRUN_OUTPUT="
    "-D_CL_HAVE_PTHREAD_MUTEX_RECURSIVE=0"
    "-DLUCENE_STATIC_CONSTANT_SYNTAX_EXITCODE=0"
    "-DLUCENE_STATIC_CONSTANT_SYNTAX_EXITCODE__TRYRUN_OUTPUT="
  ];

  patches = [
    # From debian
    ./Fix-pkgconfig-file-by-adding-clucene-shared-library.patch
    ./Fixing_ZLIB_configuration_in_shared_CMakeLists.patch
    ./Install-contribs-lib.patch
    # From arch
    ./fix-missing-include-time.patch

    # required for darwin and linux-musl
    ./pthread-include.patch

    # cmake 4 support
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-cpp/clucene/files/clucene-2.3.3.4-cmake4.patch?id=e06df280c75b0f0803954338466e5278d777f984";
      hash = "sha256-e0u6J91bnuy24hIrSl+Ap5Xwds/nzzGiWpzskwaGx9o=";
    })
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    ./fix-darwin.patch

    # see https://bugs.gentoo.org/869170
    (fetchpatch {
      url = "https://869170.bugs.gentoo.org/attachment.cgi?id=858825";
      hash = "sha256-TbAfBKdXh+1HepZc8J6OhK1XGwhwBCMvO8QBDsad998=";
    })
  ];

  # see https://github.com/macports/macports-ports/commit/236d43f2450c6be52dc42fd3a2bbabbaa5136201
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/shared/CMakeLists.txt --replace 'fstati64;_fstati64;fstat64;fstat;_fstat' 'fstat;_fstat'
    substituteInPlace src/shared/CMakeLists.txt --replace 'stati64;_stati64;stat64;stat;_stat' 'stat;_stat'
  '';

  # fails with "Unable to find executable:
  # /build/clucene-core-2.3.3.4/build/bin/cl_test"
  doCheck = false;

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=c++11-narrowing";

  meta = with lib; {
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
    homepage = "https://clucene.sourceforge.net";
    platforms = platforms.unix;
    license = with licenses; [
      asl20
      lgpl2
    ];
  };
}
