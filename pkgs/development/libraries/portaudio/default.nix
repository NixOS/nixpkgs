{ stdenv, fetchurl, alsaLib, pkgconfig, libjack2
, AudioUnit, AudioToolbox, CoreAudio, CoreServices, Carbon }:

stdenv.mkDerivation {
  name = "portaudio-190600-20161030";

  src = fetchurl {
    url = http://www.portaudio.com/archives/pa_stable_v190600_20161030.tgz;
    sha256 = "04qmin6nj144b8qb9kkd9a52xfvm0qdgm8bg8jbl7s3frmyiv8pm";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libjack2 ]
    ++ stdenv.lib.optional (!stdenv.isDarwin) alsaLib;

  configureFlags = [ "--disable-mac-universal" "--enable-cxx" ];

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.cc.isClang "-Wno-error=nullability-inferred-on-nested-type -Wno-error=nullability-completeness-on-arrays";

  propagatedBuildInputs = stdenv.lib.optionals stdenv.isDarwin [ AudioUnit AudioToolbox CoreAudio CoreServices Carbon ];

  patchPhase = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i '50 i\
      #include <CoreAudio/AudioHardware.h>\
      #include <CoreAudio/AudioHardwareBase.h>\
      #include <CoreAudio/AudioHardwareDeprecated.h>' \
      include/pa_mac_core.h
  '';

  # not sure why, but all the headers seem to be installed by the make install
  installPhase = ''
    make install
  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
    # fixup .pc file to find alsa library
    sed -i "s|-lasound|-L${alsaLib.out}/lib -lasound|" "$out/lib/pkgconfig/"*.pc
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    cp include/pa_mac_core.h $out/include/pa_mac_core.h
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
