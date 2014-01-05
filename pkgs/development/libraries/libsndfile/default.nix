{ stdenv, fetchurl, flac, libogg, libvorbis, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libsndfile-1.0.25";

  src = fetchurl {
    url = "http://www.mega-nerd.com/libsndfile/files/${name}.tar.gz";
    sha256 = "10j8mbb65xkyl0kfy0hpzpmrp0jkr12c7mfycqipxgka6ayns0ar";
  };

  buildInputs = [ pkgconfig flac libogg libvorbis ];

  # need headers from the Carbon.framework in /System/Library/Frameworks to
  # compile this on darwin -- not sure how to handle
  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin
    "-I/System/Library/Frameworks/Carbon.framework/Versions/A/Headers";

  meta = with stdenv.lib; {
    description = "A C library for reading and writing files containing sampled sound";
    homepage    = http://www.mega-nerd.com/libsndfile/;
    license     = licenses.lgpl2Plus;
    maintainers = with maintainers; [ lovek323 ];
    platfomrs   = platforms.unix;

    longDescription = ''
      Libsndfile is a C library for reading and writing files containing
      sampled sound (such as MS Windows WAV and the Apple/SGI AIFF format)
      through one standard library interface.  It is released in source
      code format under the GNU Lesser General Public License.

      The library was written to compile and run on a Linux system but
      should compile and run on just about any Unix (including MacOS X).
      There are also pre-compiled binaries available for 32 and 64 bit
      windows.

      It was designed to handle both little-endian (such as WAV) and
      big-endian (such as AIFF) data, and to compile and run correctly on
      little-endian (such as Intel and DEC/Compaq Alpha) processor systems
      as well as big-endian processor systems such as Motorola 68k, Power
      PC, MIPS and SPARC.  Hopefully the design of the library will also
      make it easy to extend for reading and writing new sound file
      formats.
    '';
  };
}
