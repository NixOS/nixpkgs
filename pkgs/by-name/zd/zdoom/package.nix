{
  lib,
  stdenv,
  fetchurl,
  p7zip,
  cmake,
  SDL2,
  openal,
  fluidsynth,
  soundfont-fluid,
  bzip2,
  zlib,
  libjpeg,
  game-music-emu,
  libsndfile,
  mpg123,
}:

stdenv.mkDerivation rec {
  pname = "zdoom";
  majorVersion = "2.8";
  version = "${majorVersion}.1";

  src = fetchurl {
    url = "https://zdoom.org/files/zdoom/${majorVersion}/zdoom-${version}-src.7z";
    sha256 = "0453fqrh9l00xwphfxni5qkf9y134n3s1mr1dvi5cbkxcva7j8bq";
  };

  nativeBuildInputs = [
    p7zip
    cmake
  ];
  buildInputs = [
    SDL2
    openal
    fluidsynth
    bzip2
    zlib
    libjpeg
    game-music-emu
    libsndfile
    mpg123
  ];

  cmakeFlags = [
    "-DFORCE_INTERNAL_GME=OFF"
    "-DGME_INCLUDE_DIR=${game-music-emu}/include"
    "-DGME_LIBRARIES=${game-music-emu}/lib/libgme.so"
  ];

  sourceRoot = ".";

  NIX_CFLAGS_LINK = [
    "-lopenal"
    "-lfluidsynth"
  ];

  preConfigure = ''
    sed -i \
      -e "s@/usr/share/sounds/sf2/@${soundfont-fluid}/share/soundfonts/@g" \
      -e "s@FluidR3_GM.sf2@FluidR3_GM2-2.sf2@g" \
      src/sound/music_fluidsynth_mididevice.cpp
  '';

  installPhase = ''
    install -Dm755 zdoom "$out/lib/zdoom/zdoom"
    for i in *.pk3; do
      install -Dm644 "$i" "$out/lib/zdoom/$i"
    done
    mkdir -p $out/bin
    ln -s $out/lib/zdoom/zdoom $out/bin/zdoom
  '';

  meta = with lib; {
    homepage = "http://zdoom.org/";
    description = "Enhanced port of the official DOOM source code";
    # Doom source license, MAME license
    license = licenses.unfreeRedistributable;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lassulus ];
  };
}
