{ stdenv, fetchurl, pkgconfig
, libvorbis, libtheora, speex }:

# need pkgconfig so that libshout installs ${out}/lib/pkgconfig/shout.pc

stdenv.mkDerivation rec {
  name = "libshout-2.4.1";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/libshout/${name}.tar.gz";
    sha256 = "0kgjpf8jkgyclw11nilxi8vyjk4s8878x23qyxnvybbgqbgbib7k";
  };

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ libvorbis libtheora speex ];

  meta = {
    description = "icecast 'c' language bindings";

    longDescription = ''
      Libshout is a library for communicating with and sending data to an icecast
      server.  It handles the socket connection, the timing of the data, and prevents
      bad data from getting to the icecast server.
    '';

    homepage = http://www.icecast.org;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
    platforms = with stdenv.lib.platforms; unix;
  };
}
