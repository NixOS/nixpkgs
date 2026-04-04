{
  lib,
  fetchgit,
  SDL,
  stdenv,
  alsa-lib,
  libGL,
  libogg,
  libvorbis,
  libmad,
  xdelta,
}:

stdenv.mkDerivation {
  pname = "uhexen2";
  # Switch to stable once it's tagged https://github.com/sezero/uhexen2/issues/76#issuecomment-3488634804
  version = "1.5.9-unstable-2026-03-15";

  src = fetchgit {
    url = "https://git.code.sf.net/p/uhexen2/uhexen2";
    rev = "adbdb95d941c7190984123cd4b7479720a294de6";
    hash = "sha256-6bPBxaIkhDGC1eUAdamuoOlJU94TJou/ZvyFRFWP4A0=";
  };

  buildInputs = [
    SDL
    alsa-lib
    libGL
    libogg
    libvorbis
    libmad
    xdelta
  ];

  preBuild = ''
    makeFiles=(
        "engine/hexen2 glh2"
        "engine/hexen2 clean"
        "engine/hexen2 h2"
        "engine/hexen2/server"
        "engine/hexenworld/client glhw"
        "engine/hexenworld/client clean"
        "engine/hexenworld/client hw"
        "engine/hexenworld/server"
        "h2patch"
    )
  '';

  buildPhase = ''
    runHook preBuild
    for makefile in "''${makeFiles[@]}"; do
          local flagsArray=(
            -j$NIX_BUILD_CORES
            SHELL=$SHELL
            $makeFlags "''${makeFlagsArray[@]}"
            $buildFlags "''${buildFlagsArray[@]}"
          )
          echoCmd 'build flags' ""''${flagsArray[@]}""
          make  -C $makefile ""''${flagsArray[@]}""
          unset flagsArray
    done
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 engine/hexen2/{glhexen2,hexen2,server/h2ded} -t $out/bin
    install -Dm755 engine/hexenworld/{client/glhwcl,client/hwcl,server/hwsv} -t $out/bin
    install -Dm755 h2patch/h2patch -t $out/bin
    runHook postInstall
  '';

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Cross-platform port of Hexen II game";
    longDescription = ''
      Hammer of Thyrion (uHexen2) is a cross-platform port of Raven Software's Hexen II source.
      It is based on an older linux port, Anvil of Thyrion.
      HoT includes countless bug fixes, improved music, sound and video modes, opengl improvements,
      support for many operating systems and architectures, and documentation among many others.
    '';
    homepage = "https://uhexen2.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ xdhampus ];
    platforms = lib.platforms.all;
  };
}
