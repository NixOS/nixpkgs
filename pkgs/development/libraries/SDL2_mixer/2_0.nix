{ fetchurl
, lzwolf
, SDL2_mixer
, timidity
}:

SDL2_mixer.overrideAttrs(oa: rec {
  version = "2.0.4";

  src = fetchurl {
    url = "https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-${version}.tar.gz";
    sha256 = "0694vsz5bjkcdgfdra6x9fq8vpzrl8m6q96gh58df7065hw5mkxl";
  };

  # fix default path to timidity.cfg so MIDI files could be played
  postPatch = ''
    substituteInPlace timidity/options.h \
      --replace "/usr/share/timidity" "${timidity}/share/timidity"
  '';

  passthru.tests.lzwolf = lzwolf;
})
