{
  lib,
  config,
  fetchzip,
  stdenv,
  SDL,
  SDL_image,
  SDL_ttf,
  SDL_mixer,
  libmysqlclient,
  wxGTK32,
  symlinkJoin,
  runCommandLocal,
  makeWrapper,
  coreutils,
  scalingFactor ? 2, # this is to resize the fixed-size zod_launcher window
  substituteAll,
}:
let
  pname = "zod-engine";
  version = "2011-09-06";
  src = fetchzip {
    url = "mirror://sourceforge/zod/linux_releases/zod_linux-${version}.tar.gz";
    sha256 = "017v96aflrv07g8j8zk9mq8f8rqxl5228rjff5blq8dxpsv1sx7h";
  };
  postPatch = ''
    sed '1i#include <ctime>' -i zod_src/common.cpp # gcc12
  '';
  nativeBuildInputs = [
    makeWrapper
  ];
  buildInputs = [
    SDL
    SDL_image
    SDL_ttf
    SDL_mixer
    libmysqlclient
    wxGTK32
    coreutils
  ];
  hardeningDisable = [ "format" ];
  NIX_LDFLAGS = "-L${libmysqlclient}/lib/mysql";
  zod_engine = stdenv.mkDerivation {
    inherit
      version
      src
      postPatch
      nativeBuildInputs
      buildInputs
      hardeningDisable
      NIX_LDFLAGS
      ;
    pname = "${pname}-engine";
    enableParallelBuilding = true;
    preBuild = "cd zod_src";
    installPhase = ''
      mkdir -p $out/bin
      install -m755 zod $out/bin/
      wrapProgram $out/bin/zod --chdir "${zod_assets}/usr/lib/commander-zod"
    '';
  };
  zod_map_editor = stdenv.mkDerivation {
    inherit
      version
      src
      postPatch
      nativeBuildInputs
      buildInputs
      hardeningDisable
      NIX_LDFLAGS
      ;
    pname = "${pname}-map_editor";
    enableParallelBuilding = true;
    preBuild = "cd zod_src";
    makeFlags = [ "map_editor" ];
    installPhase = ''
      mkdir -p $out/bin
      install -m755 zod_map_editor $out/bin
      wrapProgram $out/bin/zod_map_editor --chdir "${zod_assets}/usr/lib/commander-zod"
    '';
  };
  zod_launcher = stdenv.mkDerivation {
    inherit
      version
      src
      nativeBuildInputs
      buildInputs
      zod_engine
      zod_map_editor
      ;
    pname = "${pname}-launcher";
    # This is necessary because the zod_launcher has terrible fixed-width window
    # the Idea is to apply the scalingFactor to all positions and sizes and I tested 1,2,3 and 4
    # 2,3,4 look acceptable on my 4k monitor and 1 is unreadable.
    # also the ./ in the run command is removed to have easier time starting the game
    patches = [
      (substituteAll {
        inherit scalingFactor;
        src = ./0002-add-scaling-factor-to-source.patch;
      })
    ];
    postPatch = ''
      substituteInPlace zod_launcher_src/zod_launcherFrm.cpp \
        --replace 'message = wxT("./zod");' 'message = wxT("zod");' \
        --replace "check.replace(i,1,1,'_');" "check.replace(i,1,1,(wxUniChar)'_');"
    '';
    preBuild = "cd zod_launcher_src";
    installPhase = ''
      mkdir -p $out/bin
      install -m755 zod_launcher $out/bin
    '';
  };
  zod_assets = runCommandLocal "${pname}-assets" { } ''
    mkdir -p $out/usr/lib/commander-zod{,blank_maps}
    cp -r ${src}/assets $out/usr/lib/commander-zod/assets
    for i in ${src}/*.map ${src}/*.txt; do
      install -m644 $i $out/usr/lib/commander-zod
    done
    for map in ${src}/blank_maps/*; do
      install -m644 $map $out/usr/lib/commander-zod/blank_maps
    done
  '';
in
symlinkJoin {
  inherit pname version;
  paths = [
    zod_engine
    zod_launcher
    zod_map_editor
    zod_assets
  ];
  meta = with lib; {
    description = "Multiplayer remake of ZED";
    homepage = "http://zod.sourceforge.net/";
    maintainers = with maintainers; [ zeri ];
    license = licenses.gpl3Plus; # Says the website
    platforms = platforms.linux;
  };
}
