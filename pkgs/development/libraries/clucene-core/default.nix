{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "clucene-core";
  version = "0.9.21b";

  src = fetchurl {
    url = "mirror://sourceforge/clucene/clucene-core-${version}.tar.bz2";
    sha256 = "202ee45af747f18642ae0a088d7c4553521714a511a1a9ec99b8144cf9928317";
  };

  patches = [ ./gcc6.patch ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-std=c++11"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
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
    license = with licenses; [ asl20 lgpl2 ];
  };
}
