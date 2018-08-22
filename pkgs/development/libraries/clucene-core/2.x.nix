{stdenv, fetchurl, cmake, boost, zlib}:

stdenv.mkDerivation rec {
  name = "clucene-core-2.3.3.4";

  src = fetchurl {
    url = "mirror://sourceforge/clucene/${name}.tar.gz";
    sha256 = "1arffdwivig88kkx685pldr784njm0249k0rb1f1plwavlrw9zfx";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost zlib ];

  cmakeFlags = [ "-DBUILD_CONTRIBS=ON" "-DBUILD_CONTRIBS_LIB=ON" ];

  patches = # From debian
    [ ./Fix-pkgconfig-file-by-adding-clucene-shared-library.patch
      ./Fixing_ZLIB_configuration_in_shared_CMakeLists.patch
      ./Install-contribs-lib.patch
    ] ++ stdenv.lib.optionals stdenv.isDarwin [ ./fix-darwin.patch ];

  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    install_name_tool -change libclucene-shared.1.dylib \
        $out/lib/libclucene-shared.1.dylib \
        $out/lib/libclucene-core.1.dylib
  '';

  doCheck = false; # fails with "Unable to find executable: /build/clucene-core-2.3.3.4/build/bin/cl_test"

  meta = {
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
    platforms = stdenv.lib.platforms.unix;
  };
}
