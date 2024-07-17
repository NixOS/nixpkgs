{
  stdenv,
  lib,
  fetchurl,
  fetchpatch,
  SDL,
  libogg,
  libvorbis,
  smpeg,
  libmikmod,
  fluidsynth,
  pkg-config,
  enableNativeMidi ? false,
}:

stdenv.mkDerivation rec {
  pname = "SDL_mixer";
  version = "1.2.12";

  src = fetchurl {
    url = "http://www.libsdl.org/projects/${pname}/release/${pname}-${version}.tar.gz";
    sha256 = "0alrhqgm40p4c92s26mimg9cm1y7rzr6m0p49687jxd9g6130i0n";
  };

  patches = [
    # Fixes implicit declaration of `Mix_QuitFluidSynth`, which causes build failures with clang.
    # https://github.com/libsdl-org/SDL_mixer/issues/287
    (fetchpatch {
      name = "fluidsynth-fix-implicit-declaration.patch";
      url = "https://github.com/libsdl-org/SDL_mixer/commit/05b12a3c22c0746c29dc5478f5b7fbd8a51a1303.patch";
      hash = "sha256-MDuViLD1w1tAVLoX2yFeJ865v21S2roi0x7Yi7GYRVU=";
    })
    # Backport of 2.0 fixes for incompatible function pointer conversions, fixing builds with clang.
    (fetchpatch {
      name = "fluidsynth-fix-function-pointer-conversions.patch";
      url = "https://github.com/libsdl-org/SDL_mixer/commit/0c504159d212b710a47cb25c669b21730fc78edd.patch";
      hash = "sha256-FSj7JLE2MbGVYCspoq3trXP5Ho+lAtnro2IUOHkto/U";
    })
    # Backport of MikMod fixes, which includes incompatible function pointer conversions.
    (fetchpatch {
      name = "mikmod-fixes.patch";
      url = "https://github.com/libsdl-org/SDL_mixer/commit/a3e5ff8142cf3530cddcb27b58f871f387796ab6.patch";
      hash = "sha256-dqD8hxx6U2HaelUx0WsGPiWuso++LjwasaAeTTGqdbk";
    })
    # More incompatible function pointer conversion fixes (this time in Vorbis-decoding code).
    (fetchpatch {
      name = "vorbis-fix-function-pointer-conversion.patch";
      url = "https://github.com/libsdl-org/SDL_mixer/commit/9e6d7b67a00656a68ea0c2eace75c587871549b9.patch";
      hash = "sha256-rZI3bFb/KxnduTkA/9CISccKHUgrX22KXg69sl/uXvU=";
    })
    (fetchpatch {
      name = "vorbis-fix-function-pointer-conversion-header-part.patch";
      url = "https://github.com/libsdl-org/SDL_mixer/commit/03bd4ca6aa38c1a382c892cef86296cd621ecc1d.patch";
      hash = "sha256-7HrSHYFYVgpamP7Q9znrFZMZ72jvz5wYpJEPqWev/I4=";
    })
    (fetchpatch {
      name = "vorbis-fix-function-pointer-signature.patch";
      url = "https://github.com/libsdl-org/SDL_mixer/commit/d28cbc34d63dd20b256103c3fe506ecf3d34d379.patch";
      hash = "sha256-sGbtF+Tcjf+6a28nJgawefeeKXnhcwu7G55e94oS9AU=";
    })
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    SDL
    libogg
    libvorbis
    fluidsynth
    smpeg
    libmikmod
  ];

  configureFlags =
    [
      "--disable-music-ogg-shared"
      "--disable-music-mod-shared"
    ]
    ++ lib.optional enableNativeMidi " --enable-music-native-midi-gpl"
    ++ lib.optionals stdenv.isDarwin [
      "--disable-sdltest"
      "--disable-smpegtest"
    ];

  meta = with lib; {
    description = "SDL multi-channel audio mixer library";
    homepage = "http://www.libsdl.org/projects/SDL_mixer/";
    maintainers = with maintainers; [ lovek323 ];
    platforms = platforms.unix;
    license = licenses.zlib;
  };
}
