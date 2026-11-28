{
  lib,
  fetchurl,
  stdenv,
  runtimeShell,
  SDL2,
  freealut,
  SDL2_image,
  openal,
  physfs,
  zlib,
  libGLU,
  libGL,
  glew,
  tinyxml-2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "trigger-rally";
  version = "0.6.7";

  src = fetchurl {
    url = "mirror://sourceforge/trigger-rally/trigger-rally-${finalAttrs.version}.tar.gz";
    hash = "sha256-ZAaR+jzhKX8oyYP4dRTcbzAsKJZqxgo72l+CWVxr3+c=";
  };

  buildInputs = [
    SDL2
    freealut
    SDL2_image
    openal
    physfs
    zlib
    libGLU
    libGL
    glew
    tinyxml-2
  ];

  preConfigure = ''
    sed s,/usr/local,$out, -i bin/*defs

    cd src

    sed s,lSDL2main,lSDL2, -i GNUmakefile
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${lib.getInclude SDL2}/include/SDL2"
  '';

  makeFlags = [
    "prefix=${placeholder "out"}"
    # Hardcoded to /usr/share/… upstream
    "LOC_DESKTOPFILE=${placeholder "out"}/share/applications"
    "LOC_APPDATAFILE=${placeholder "out"}/share/metainfo"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p $out/bin
    cat <<EOF > $out/bin/trigger-rally
    #!${runtimeShell}
    exec $out/games/trigger-rally "$@"
    EOF
    chmod +x $out/bin/trigger-rally

    install -Dm644 $out/share/games/trigger-rally/icon/trigger-rally-icons.svg $out/share/icons/hicolor/scalable/apps/trigger-rally.svg
  '';

  meta = {
    description = "Fast-paced single-player racing game";
    mainProgram = "trigger-rally";
    homepage = "http://trigger-rally.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = with lib.platforms; linux;
  };
})
