{ lib, stdenv, fetchurl
, nasmSupport ? true, nasm # Assembly optimizations
, cpmlSupport ? true # Compaq's fast math library
#, efenceSupport ? false, libefence # Use ElectricFence for malloc debugging
, sndfileFileIOSupport ? false, libsndfile # Use libsndfile, instead of lame's internal routines
, analyzerHooksSupport ? true # Use analyzer hooks
, decoderSupport ? true # mpg123 decoder
, frontendSupport ? true # Build the lame executable
#, mp3xSupport ? false, gtk1 # Build GTK frame analyzer
, mp3rtpSupport ? false # Build mp3rtp
, debugSupport ? false # Debugging (disables optimizations)
}:

stdenv.mkDerivation rec {
  pname = "lame";
  version = "3.100";

  src = fetchurl {
    url = "mirror://sourceforge/lame/${pname}-${version}.tar.gz";
    sha256 = "07nsn5sy3a8xbmw1bidxnsj5fj6kg9ai04icmqw40ybkp353dznx";
  };

  outputs = [ "out" "lib" "doc" ]; # a small single header
  outputMan = "out";

  nativeBuildInputs = [ ]
    ++ lib.optional nasmSupport nasm;

  buildInputs = [ ]
    #++ optional efenceSupport libefence
    #++ optional mp3xSupport gtk1
    ++ lib.optional sndfileFileIOSupport libsndfile;

  configureFlags = [
    (lib.enableFeature nasmSupport "nasm")
    (lib.enableFeature cpmlSupport "cpml")
    #(enableFeature efenceSupport "efence")
    (if sndfileFileIOSupport then "--with-fileio=sndfile" else "--with-fileio=lame")
    (lib.enableFeature analyzerHooksSupport "analyzer-hooks")
    (lib.enableFeature decoderSupport "decoder")
    (lib.enableFeature frontendSupport "frontend")
    (lib.enableFeature frontendSupport "dynamic-frontends")
    #(enableFeature mp3xSupport "mp3x")
    (lib.enableFeature mp3rtpSupport "mp3rtp")
    (lib.optionalString debugSupport "--enable-debug=alot")
  ];

  preConfigure = ''
    # Prevent a build failure for 3.100 due to using outdated symbol list
    # https://hydrogenaud.io/index.php/topic,114777.msg946373.html#msg946373
    sed -i '/lame_init_old/d' include/libmp3lame.sym
  '';

  meta = with lib; {
    description = "High quality MPEG Audio Layer III (MP3) encoder";
    homepage    = "http://lame.sourceforge.net";
    license     = licenses.lgpl2;
    maintainers = with maintainers; [ codyopel ];
    platforms   = platforms.all;
    mainProgram = "lame";
  };
}
