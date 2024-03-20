{ lib
, stdenv
, fetchFromGitHub
, cmake
, makeWrapper
# python311 causes trouble
# https://github.com/vegastrike/Vega-Strike-Engine-Source/issues/777
# Will be fixed in next release. There is alternatively a patch that fixes this
# and allows to switch to latest python if needed
, python310
, libpng
, libjpeg
, expat
, gtk3
, glib
, openal
, libogg
, libvorbis
, SDL
, boost
, python310Packages
, freeglut
, vegastrike-utcs-data
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vegastrike";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "vegastrike";
    repo = "Vega-Strike-Engine-Source";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8NwXp7PDh8DL777LZcpyC2UmKFwzg1XKIGrL5hzKpbg=";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  buildInputs = [
    python310
    libpng
    libjpeg
    expat
    gtk3
    glib
    openal
    libogg
    libvorbis
    SDL
    boost
    python310Packages.boost
    freeglut
    vegastrike-utcs-data
  ];

  # the bundled FindGTK3.cmake causes trouble, so we hack around it
  cmakeFlags = [
    "-DGTK3_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
  ];

  sourceRoot = "${finalAttrs.src.name}/engine";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    # expose the unwrapped binaries because the engine can run other games,
    # not only "Upon The Coldest Sea"
    cp vegastrike-engine $out/bin
    cp setup/vegasettings $out/bin

    # upstream says the wrappers for "Upon The Coldest Sea" shall be named vs
    # and vsettings
    # https://github.com/vegastrike/Vega-Strike-Engine-Source/?tab=readme-ov-file#executable-name-changes
    makeWrapper $out/bin/vegastrike-engine $out/bin/vs \
      --add-flags '-d${vegastrike-utcs-data}'
    makeWrapper $out/bin/vegasettings $out/bin/vsettings \
      --add-flags '--target ${vegastrike-utcs-data}'

    runHook postInstall
  '';

  meta = with lib; {
    description = "A Space Flight Simulator that allows a player to explore, trade, and fight in the vast open space";
    longDescription = ''
      Vega Strike is a Space Flight Simulator that allows a player to explore, trade, and fight in the vast open space. You start in an old beat up cargo ship, with endless possibilities in front of you and just enough cash to scrape together a life. Yet danger lurks in the space beyond.
    '';
    homepage = "https://www.vega-strike.org";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ TheBrainScrambler ];
    platforms = platforms.linux;
  };
})
