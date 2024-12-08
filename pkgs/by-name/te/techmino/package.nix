{ lib
, stdenv
, fetchurl
, callPackage
, makeWrapper
, makeDesktopItem
, love
, luajit
, writeShellScript
, nix-update
, libcoldclear ? callPackage ./libcoldclear.nix { inherit ccloader; }
, ccloader ? callPackage ./ccloader.nix { inherit libcoldclear luajit; }
}:

let
  pname = "techmino";
  description = "A modern Tetris clone with many features";

  desktopItem = makeDesktopItem {
    name = pname;
    exec = "techmino";
    icon = fetchurl {
      name = "techmino.png";
      url = "https://github.com/26F-Studio/Techmino/assets/9590981/95981af1-f39a-47d9-bd99-a78ab767c08f";
      hash = "sha256-+j+8m2vwaWgHYSFL6urvTcB0vA+PCZ+FYJ22CNXfcSc=";
    };
    comment = description;
    desktopName = "Techmino";
    genericName = "Tetris Clone";
    categories = [ "Game" ];
  };
in

stdenv.mkDerivation rec {
  inherit pname;
  version = "0.17.21";

  src = fetchurl {
    url = "https://github.com/26F-Studio/Techmino/releases/download/v${version}/Techmino_Bare.love";
    hash = "sha256-8gMIyNP1FS52LnbpQ+G9XNtK3rQruzkMDRz7Gk9LZcQ=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/games/lovegames
    cp $src $out/share/games/lovegames/techmino.love

    mkdir -p $out/bin
    makeWrapper ${love}/bin/love $out/bin/techmino \
      --add-flags $out/share/games/lovegames/techmino.love \
      --suffix LUA_CPATH : ${ccloader}/lib/lua/${luajit.luaversion}/CCLoader.so

    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/

    runHook postInstall
  '';

  passthru = {
    inherit ccloader libcoldclear;
    updateScript = writeShellScript "update-script.sh" ''
      if ${lib.getExe nix-update} techmino | grep "Packages updated"; then
        ${lib.getExe nix-update} techmino.ccloader
      fi
    '';
  };

  meta = with lib; {
    inherit description;
    downloadPage = "https://github.com/26F-Studio/Techmino/releases";
    homepage = "https://github.com/26F-Studio/Techmino/";
    license = licenses.lgpl3;
    mainProgram = "techmino";
    maintainers = with maintainers; [ chayleaf ];
  };
}
