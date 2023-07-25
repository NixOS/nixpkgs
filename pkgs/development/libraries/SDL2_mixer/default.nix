{ lib, stdenv
, fetchurl
, pkg-config
, AudioToolbox
, AudioUnit
, CoreServices
, SDL2
, flac
, fluidsynth
, libmodplug
, libogg
, libvorbis
, mpg123
, opusfile
, smpeg2
, timidity
}:

stdenv.mkDerivation rec {
  pname = "SDL2_mixer";
  version = "2.6.3";

  src = fetchurl {
    url = "https://www.libsdl.org/projects/SDL_mixer/release/${pname}-${version}.tar.gz";
    sha256 = "sha256-emuoakeGSM5hfjpekncYG8Z/fOmHZgXupq/9Sg1u6o8=";
  };

  configureFlags = [
    "--disable-music-ogg-shared"
    "--disable-music-flac-shared"
    "--disable-music-mod-modplug-shared"
    "--disable-music-mp3-mpg123-shared"
    "--disable-music-opus-shared"
    "--disable-music-midi-fluidsynth-shared"

    # override default path to allow MIDI files to be played
    "--with-timidity-cfg=${timidity}/share/timidity/timidity.cfg"
  ] ++ lib.optionals stdenv.isDarwin [
    "--disable-sdltest"
    "--disable-smpegtest"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals stdenv.isDarwin [
    AudioToolbox
    AudioUnit
    CoreServices
  ];

  propagatedBuildInputs = [
    SDL2
    flac
    fluidsynth
    libmodplug
    libogg
    libvorbis
    mpg123
    opusfile
    smpeg2
    # MIDI patterns
    timidity
  ];

  outputs = [ "out" "dev" ];

  meta = with lib; {
    description = "SDL multi-channel audio mixer library";
    platforms = platforms.unix;
    homepage = "https://github.com/libsdl-org/SDL_mixer";
    maintainers = with maintainers; [ MP2E ];
    license = licenses.zlib;
  };
}
