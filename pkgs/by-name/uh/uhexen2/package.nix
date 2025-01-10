{
  lib,
  fetchgit,
  SDL,
  stdenv,
  libogg,
  libvorbis,
  libmad,
  xdelta,
}:

stdenv.mkDerivation rec {
  pname = "uhexen2";
  version = "1.5.9";

  src = fetchgit {
    url = "https://git.code.sf.net/p/uhexen2/uhexen2";
    sha256 = "0crdihbnb92awkikn15mzdpkj1x9s34xixf1r7fxxf762m60niks";
    rev = "4ef664bc41e3998b0d2a55ff1166dadf34c936be";
  };

  buildInputs = [
    SDL
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

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Cross-platform port of Hexen II game";
    longDescription = ''
      Hammer of Thyrion (uHexen2) is a cross-platform port of Raven Software's Hexen II source.
      It is based on an older linux port, Anvil of Thyrion.
      HoT includes countless bug fixes, improved music, sound and video modes, opengl improvements,
      support for many operating systems and architectures, and documentation among many others.
    '';
    homepage = "https://uhexen2.sourceforge.net/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ xdhampus ];
    platforms = platforms.all;
  };
}
