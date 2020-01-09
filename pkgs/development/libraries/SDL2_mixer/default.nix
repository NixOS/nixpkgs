{ stdenv, lib, fetchurl, autoreconfHook, pkgconfig, which
, SDL2, libogg, libvorbis, smpeg2, flac, libmodplug, opusfile
, CoreServices, AudioUnit, AudioToolbox
, enableNativeMidi ? false, fluidsynth ? null }:

stdenv.mkDerivation rec {
  pname = "SDL2_mixer";
  version = "2.0.4";

  src = fetchurl {
    url = "https://www.libsdl.org/projects/SDL_mixer/release/${pname}-${version}.tar.gz";
    sha256 = "0694vsz5bjkcdgfdra6x9fq8vpzrl8m6q96gh58df7065hw5mkxl";
  };

  preAutoreconf = ''
    aclocal
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig which ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ CoreServices AudioUnit AudioToolbox ];

  propagatedBuildInputs = [ SDL2 libogg libvorbis fluidsynth smpeg2 flac libmodplug opusfile ];

  configureFlags = [ "--disable-music-ogg-shared" ]
    ++ lib.optional enableNativeMidi "--enable-music-native-midi-gpl"
    ++ lib.optionals stdenv.isDarwin [ "--disable-sdltest" "--disable-smpegtest" ];

  meta = with stdenv.lib; {
    description = "SDL multi-channel audio mixer library";
    platforms = platforms.unix;
    homepage = https://www.libsdl.org/projects/SDL_mixer/;
    maintainers = with maintainers; [ MP2E ];
    license = licenses.zlib;
  };
}
