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
  version = "2.0.4";

  src = fetchurl {
    url = "https://www.libsdl.org/projects/SDL_mixer/release/${pname}-${version}.tar.gz";
    sha256 = "0694vsz5bjkcdgfdra6x9fq8vpzrl8m6q96gh58df7065hw5mkxl";
  };

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

  # fix default path to timidity.cfg so MIDI files could be played
  postPatch = ''
    substituteInPlace timidity/options.h \
      --replace "/usr/share/timidity" "${timidity}/share/timidity"
  '';

  configureFlags = [
    "--disable-music-ogg-shared"
    "--disable-music-flac-shared"
    "--disable-music-mod-modplug-shared"
    "--disable-music-mp3-mpg123-shared"
    "--disable-music-opus-shared"
    "--disable-music-midi-fluidsynth-shared"
  ] ++ lib.optionals stdenv.isDarwin [
    "--disable-sdltest"
    "--disable-smpegtest"
  ];

  meta = with lib; {
    description = "SDL multi-channel audio mixer library";
    platforms = platforms.unix;
    homepage = "https://www.libsdl.org/projects/SDL_mixer/";
    maintainers = with maintainers; [ MP2E ];
    license = licenses.zlib;
  };
}
