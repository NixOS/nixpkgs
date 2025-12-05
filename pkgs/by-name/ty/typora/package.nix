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
  libgbm,
  expat,
  alsa-lib,
  buildFHSEnv,
  writeTextFile,
}:

let
  pname = "typora";
  version = "1.12.4";

  src =
    fetchurl
      {
        x86_64-linux = {
          urls = [
            "https://download.typora.io/linux/typora_${version}_amd64.deb"
            "https://downloads.typoraio.cn/linux/typora_${version}_amd64.deb"
          ];
          hash = "sha256-P3wgzMVcyvmXM/w24kPgYGOfSaAh+SFzgeoJoasEmH8=";
        };
        aarch64-linux = {
          urls = [
            "https://download.typora.io/linux/typora_${version}_arm64.deb"
            "https://downloads.typoraio.cn/linux/typora_${version}_arm64.deb"
          ];
          hash = "sha256-tQFCppOeeWJK8ovf71LPJRVteOJ8XbbNojhV4QLmVJ0=";
        };
      }
      .${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");

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
        libgbm
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
  inherit pname version src;

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

  passthru.updateScript = ./update.sh;

  meta = {
    description = "A minimal Markdown editor and reader.";
    homepage = "https://typora.io/";
    changelog = "https://typora.io/releases/all";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      npulidomateo
      chillcicada
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "typora";
  };
}
