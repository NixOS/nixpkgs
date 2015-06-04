{ stdenv, fetchurl
, nasmSupport ? true, nasm ? null # Assembly optimizations
, cpmlSupport ? true # Compaq's fast math library
#, efenceSupport ? false, libefence ? null # Use ElectricFence for malloc debugging
, sndfileFileIOSupport ? false, libsndfile ? null # Use libsndfile, instead of lame's internal routines
, analyzerHooksSupport ? true # Use analyzer hooks
, decoderSupport ? true # mpg123 decoder
, frontendSupport ? true # Build the lame executable
#, mp3xSupport ? false, gtk1 ? null # Build GTK frame analyzer
, mp3rtpSupport ? false # Build mp3rtp
, debugSupport ? false # Debugging (disables optimizations)
}:

assert nasmSupport -> (nasm != null);
#assert efenceSupport -> (libefence != null);
assert sndfileFileIOSupport -> (libsndfile != null);
#assert mp3xSupport -> (analyzerHooksSupport && (gtk1 != null));

let
  sndfileFileIO = if sndfileFileIOSupport then "sndfile" else "lame";
in

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "lame-${version}";
  version = "3.99.5";

  src = fetchurl {
    url = "mirror://sourceforge/lame/${name}.tar.gz";
    sha256 = "1zr3kadv35ii6liia0bpfgxpag27xcivp571ybckpbz4b10nnd14";
  };

  patches = [ ./gcc-4.9.patch ];

  nativeBuildInputs = [ ]
    ++ optional nasmSupport nasm;

  buildInputs = [ ]
    #++ optional efenceSupport libefence
    #++ optional mp3xSupport gtk1
    ++ optional sndfileFileIOSupport libsndfile;

  configureFlags = [
    (mkEnable nasmSupport          "nasm"              null)
    (mkEnable cpmlSupport          "cpml"              null)
    #(mkEnable efenceSupport        "efence"            null)
    (mkWith   true                 "fileio"            sndfileFileIO)
    (mkEnable analyzerHooksSupport "analyzer-hooks"    null)
    (mkEnable decoderSupport       "decoder"           null)
    (mkEnable frontendSupport      "frontend"          null)
    (mkEnable frontendSupport      "dynamic-frontends" null)
    #(mkEnable mp3xSupport          "mp3x"              null)
    (mkEnable mp3rtpSupport        "mp3rtp"            null)
  ] ++ optional debugSupport [
    (mkEnable true                 "debug"             "alot")
  ];

  meta = {
    description = "A high quality MPEG Audio Layer III (MP3) encoder";
    homepage    = http://lame.sourceforge.net;
    license     = licenses.lgpl2;
    maintainers = with maintainers; [ codyopel ];
    platforms   = platforms.all;
  };
}
