{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, cmake
, SDL2
, flac
, libmikmod
, libvorbis
, timidity
, AudioToolbox
, CoreAudio
}:

stdenv.mkDerivation rec {
  pname = "SDL2_sound";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "icculus";
    repo = "SDL_sound";
    rev = "v${version}";
    sha256 = "sha256-N2znqy58tMHgYa07vEsSedWLRhoJzDoINcsUu0UYLnA=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/icculus/SDL_sound/pull/32 - fix build on darwin
      # can be dropped on the next update
      url = "https://github.com/icculus/SDL_sound/commit/c15d75b7720113b28639baad284f45f943846294.patch";
      sha256 = "sha256-4GL8unsZ7eNkzjLXq9QdaxFQMzX2tdP0cBR1jTaRLc0=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DSDLSOUND_DECODER_MIDI=1" ];

  buildInputs = [ SDL2 flac libmikmod libvorbis timidity ]
    ++ lib.optionals stdenv.isDarwin [ AudioToolbox CoreAudio ];

  meta = with lib; {
    description = "SDL2 sound library";
    mainProgram = "playsound";
    platforms = platforms.unix;
    license = licenses.zlib;
    homepage = "https://www.icculus.org/SDL_sound/";
  };
}
