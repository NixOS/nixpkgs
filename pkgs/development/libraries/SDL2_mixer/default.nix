{ stdenv, lib, fetchurl, autoreconfHook, pkgconfig, which
, SDL2, libogg, libvorbis, smpeg2, flac, libmodplug
, CoreServices, AudioUnit, AudioToolbox
, enableNativeMidi ? false, fluidsynth ? null }:

stdenv.mkDerivation rec {
  name = "SDL2_mixer-${version}";
  version = "2.0.2";

  src = fetchurl {
    url = "https://www.libsdl.org/projects/SDL_mixer/release/${name}.tar.gz";
    sha256 = "1fw3kkqi5346ai5if4pxrcbhs5c4vv3a4smgz6fl6kyaxwkmwqaf";
  };

  preAutoreconf = ''
    aclocal
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig which ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ CoreServices AudioUnit AudioToolbox ];

  propagatedBuildInputs = [ SDL2 libogg libvorbis fluidsynth smpeg2 flac libmodplug ];

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
