{
  stdenv,
  fetchurl,
  dpkg,
  lib,
  glib,
  nss,
  nspr,
  cups,
  dbus,
  libdrm,
  gtk3,
  pango,
  cairo,
  libxkbcommon,
  mesa,
  expat,
  alsa-lib,
  buildFHSEnv,
  writeTextFile,
}:

let
  pname = "typora";
  version = "1.9.3";
  src = fetchurl {
    url = "https://download.typora.io/linux/typora_${version}_amd64.deb";
    hash = "sha256-3rR/CvFFjRPkz27mm1Wt5hwgRUnLL7lpLFKA2moILx8=";
  };

  typoraBase = stdenv.mkDerivation {
    inherit pname version src;

    nativeBuildInputs = [ dpkg ];

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin $out/share
      mv usr/share $out
      ln -s $out/share/typora/Typora $out/bin/Typora
      runHook postInstall
    '';
  };

  typoraFHS = buildFHSEnv {
    pname = "typora-fhs";
    inherit version;
    targetPkgs =
      pkgs:
      (with pkgs; [
        typoraBase
        udev
        alsa-lib
        glib
        nss
        nspr
        atk
        cups
        dbus
        gtk3
        libdrm
        pango
        cairo
        mesa
        libGL
        expat
        libxkbcommon
      ])
      ++ (with pkgs.xorg; [
        libX11
        libXcursor
        libXrandr
        libXcomposite
        libXdamage
        libXext
        libXfixes
        libxcb
      ]);
    runScript = ''
      Typora "$@"
    '';
  };

  launchScript = writeTextFile {
    name = "typora-launcher";
    executable = true;
    text = ''
      #!${stdenv.shell}

      # Configuration directory setup
      XDG_CONFIG_HOME=''${XDG_CONFIG_HOME:-~/.config}
      TYPORA_CONFIG_DIR="$XDG_CONFIG_HOME/Typora"
      TYPORA_DICT_DIR="$TYPORA_CONFIG_DIR/typora-dictionaries"

      # Create config directories with proper permissions
      mkdir -p "$TYPORA_DICT_DIR"
      chmod 755 "$TYPORA_CONFIG_DIR"
      chmod 755 "$TYPORA_DICT_DIR"

      # Read user flags if they exist
      if [ -f "$XDG_CONFIG_HOME/typora-flags.conf" ]; then
        TYPORA_USER_FLAGS="$(sed 's/#.*//' "$XDG_CONFIG_HOME/typora-flags.conf" | tr '\n' ' ')"
      fi

      exec ${typoraFHS}/bin/typora-fhs "$@" $TYPORA_USER_FLAGS
    '';
  };

in
stdenv.mkDerivation {
  inherit pname version;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    ln -s ${launchScript} $out/bin/typora
    ln -s ${typoraBase}/share/ $out
    runHook postInstall
  '';

  meta = with lib; {
    description = "Markdown editor, a markdown reader";
    homepage = "https://typora.io/";
    license = licenses.unfree;
    maintainers = with maintainers; [ npulidomateo ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "typora";
  };
}
