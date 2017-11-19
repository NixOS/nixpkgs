{ stdenv, fetchurl, flac, libogg, libvorbis, pkgconfig
, Carbon, AudioToolbox
}:

stdenv.mkDerivation rec {
  name = "libsndfile-1.0.28";

  src = fetchurl {
    url = "http://www.mega-nerd.com/libsndfile/files/${name}.tar.gz";
    sha256 = "1afzm7jx34jhqn32clc5xghyjglccam2728yxlx37yj2y0lkkwqz";
  };

  patches = [
    (fetchurl {
      name = "CVE-2017-12562.patch";
      url = "https://github.com/erikd/libsndfile/commit/cf7a8182c2642c50f1cf90dddea9ce96a8bad2e8.patch";
      sha256 = "1jg3wq30wdn9nv52mcyv6jyi4d80h4r1h9p96czcria7l91yh4sy";
    })
    (fetchurl {
      name = "CVE-2017-6892.patch";
      url = "https://github.com/erikd/libsndfile/commit/f833c53cb596e9e1792949f762e0b33661822748.patch";
      sha256 = "05xkmz2ihc1zcj73sbmj1ikrv9qlcym2bkp1v6ak7w53ky619mwq";
    })
    (fetchurl {
      name = "CVE-2017-8361+CVE-2017-8363+CVE-2017-8365.patch";
      url = "https://github.com/erikd/libsndfile/commit/fd0484aba8e51d16af1e3a880f9b8b857b385eb3.patch";
      sha256 = "0ccndnvjzx5fw18zvy03vnb29rr81h5vsh1m16msqbxk8ibndln2";
    })
    (fetchurl {
      name = "CVE-2017-8362.patch";
      url = "https://github.com/erikd/libsndfile/commit/ef1dbb2df1c0e741486646de40bd638a9c4cd808.patch";
      sha256 = "1xyv30ga71cpy4wx5f76sc4dma91la2lcc6s9f3pk9rndyi7gj9x";
    })
    (fetchurl {
      name = "CVE-2017-14634.patch";
      url = "https://github.com/erikd/libsndfile/commit/85c877d5072866aadbe8ed0c3e0590fbb5e16788.patch";
      sha256 = "0kc7vp22qsxidhvmlc6nfamw7k92n0hcfpmwhb3gaksjamwhb2df";
    })
  ];

  buildInputs = [ pkgconfig flac libogg libvorbis ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Carbon AudioToolbox ];

  enableParallelBuilding = true;

  outputs = [ "bin" "dev" "out" "man" "doc" ];

  # need headers from the Carbon.framework in /System/Library/Frameworks to
  # compile this on darwin -- not sure how to handle
  preConfigure = stdenv.lib.optionalString stdenv.isDarwin
    ''
      NIX_CFLAGS_COMPILE+=" -I$SDKROOT/System/Library/Frameworks/Carbon.framework/Versions/A/Headers"
    '';

  # Needed on Darwin.
  NIX_CFLAGS_LINK = "-logg -lvorbis";

  meta = with stdenv.lib; {
    description = "A C library for reading and writing files containing sampled sound";
    homepage    = http://www.mega-nerd.com/libsndfile/;
    license     = licenses.lgpl2Plus;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;

    longDescription = ''
      Libsndfile is a C library for reading and writing files containing
      sampled sound (such as MS Windows WAV and the Apple/SGI AIFF format)
      through one standard library interface.  It is released in source
      code format under the GNU Lesser General Public License.

      The library was written to compile and run on a Linux system but
      should compile and run on just about any Unix (including macOS).
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
