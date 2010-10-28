{stdenv, fetchurl, flac, libogg, libvorbis, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libsndfile-1.0.23";

  src = fetchurl {
    url = "http://www.mega-nerd.com/libsndfile/files/${name}.tar.gz";
    sha256 = "0k9x4804gfh9d9zd4rm1v2izm8l716rzk4d6jlrjcf45b5sw7jal";
  };

  buildInputs = [pkgconfig flac libogg libvorbis];

  meta = {
    description = "Libsndfile, a C library for reading and writing files containing sampled sound";

    longDescription =
      '' Libsndfile is a C library for reading and writing files containing
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

    homepage = http://www.mega-nerd.com/libsndfile/;

    license = "LGPLv2+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
