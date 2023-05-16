{ fetchurl
<<<<<<< HEAD
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  patches = [
    # These patches fix incompatible function pointer conversion errors with clang 16.
    (fetchpatch {
      url = "https://github.com/libsdl-org/SDL_mixer/commit/4119ec3fe838d38d2433f4432cd18926bda5d093.patch";
      stripLen = 2;
      hash = "sha256-Ug1EEZIRcV8+e1MeMsGHuTW7Zn6j4szqujP8IkIq2VM=";
    })
    # Based on https://github.com/libsdl-org/SDL_mixer/commit/64ab759111ddb1b033bcce64e1a04e0cba6e498f
    ./SDL_mixer-2.0-incompatible-pointer-comparison-fix.patch
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # fix default path to timidity.cfg so MIDI files could be played
  postPatch = ''
    substituteInPlace timidity/options.h \
      --replace "/usr/share/timidity" "${timidity}/share/timidity"
  '';

  passthru.tests.lzwolf = lzwolf;
})
