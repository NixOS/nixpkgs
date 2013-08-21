{ stdenv, fetchurl, alsaLib, pkgconfig }:

stdenv.mkDerivation rec {
  name = "portaudio-19-20111121";
  
  src = fetchurl {
    url = http://www.portaudio.com/archives/pa_stable_v19_20111121.tgz;
    sha256 = "168vmcag3c5y3zwf7h5298ydh83g72q5bznskrw9cr2h1lrx29lw";
  };

  buildInputs = [ pkgconfig ]
    ++ stdenv.lib.optional (!stdenv.isDarwin) alsaLib;

  configureFlags = stdenv.lib.optionals stdenv.isDarwin
    [ "--build=x86_64" "--without-oss" "--enable-static" "--enable-shared" ];

  preBuild = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i '50 i\
      #include <CoreAudio/AudioHardware.h>\
      #include <CoreAudio/AudioHardwareBase.h>\
      #include <CoreAudio/AudioHardwareDeprecated.h>' \
      include/pa_mac_core.h

    # disable two tests that don't compile
    sed -i -e 105d Makefile
    sed -i -e 107d Makefile
  '';

  # not sure why, but all the headers seem to be installed by the make install
  installPhase = if stdenv.isDarwin then ''
    mkdir -p "$out"
    cp -r include "$out"
    cp -r lib "$out"
  '' else ''
    make install
  '';

  meta = with stdenv.lib; {
    description = "Portable cross-platform Audio API";
    homepage    = http://www.portaudio.com/;
    # Not exactly a bsd license, but alike
    license     = licenses.mit;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };

  passthru = {
    api_version = 19;
  };
}
