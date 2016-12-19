{ stdenv, fetchurl, libogg, pkgconfig }:

stdenv.mkDerivation rec {
  name = "liboggz-1.1.1";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/liboggz/${name}.tar.gz";
    sha256 = "0nj17lhnsw4qbbk8jy4j6a78w6v2llhqdwq46g44mbm9w2qsvbvb";
  };

  propagatedBuildInputs = [ libogg ];

  buildInputs = [ pkgconfig ];

  meta = {
    homepage = http://xiph.org/oggz/;
    description = "A C library and tools for manipulating with Ogg files and streams";
    longDescription = ''
      Oggz comprises liboggz and the tool oggz, which provides commands to
      inspect, edit and validate Ogg files. The oggz-chop tool can also be used
      to serve time ranges of Ogg media over HTTP by any web server that
      supports CGI.

      liboggz is a C library for reading and writing Ogg files and streams.  It
      offers various improvements over the reference libogg, including support
      for seeking, validation and timestamp interpretation. Ogg is an
      interleaving data container developed by Monty at Xiph.Org, originally to
      support the Ogg Vorbis audio format but now used for many free codecs
      including Dirac, FLAC, Speex and Theora.'';
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.unix;
  };
}
