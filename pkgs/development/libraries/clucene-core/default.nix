{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "clucene-core-0.9.21b";

  src = fetchurl {
    url = "mirror://sourceforge/clucene/${name}.tar.bz2";
    sha256 = "202ee45af747f18642ae0a088d7c4553521714a511a1a9ec99b8144cf9928317";
  };
  
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
    platforms = stdenv.lib.platforms.linux;
  };
}
