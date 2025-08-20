{
  stdenv,
  lib,
  fetchzip,
  fetchurl,
  gtk3,
  jre8,
  libXtst,
  makeWrapper,
  makeDesktopItem,
  runtimeShell,
}:

stdenv.mkDerivation rec {
  pname = "xmind";
  version = "8-update9";

  src = fetchzip {
    url = "https://www.xmind.app/xmind/downloads/${pname}-${version}-linux.zip";
    stripRoot = false;
    sha256 = "9769c4a9d42d3370ed2c2d1bed5a5d78f1fc3dc5bd604b064b56101fc7f90bb4";
  };

  srcIcon = fetchurl {
    url = "https://aur.archlinux.org/cgit/aur.git/plain/xmind.png?h=xmind&id=41936c866b244b34d7dfbee373cbb835eed7860b";
    sha256 = "0jxq2fiq69q9ly0m6hx2qfybqad22sl42ciw636071khpqgc885f";
  };

  preferLocalBuild = true;

  patches = [ ./java-env-config-fixes.patch ];

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;
  dontPatchELF = true;
  dontStrip = true;

  libPath = lib.makeLibraryPath [
    gtk3
    libXtst
  ];

  desktopItem = makeDesktopItem {
    name = "XMind";
    exec = "XMind";
    icon = "xmind";
    desktopName = "XMind";
    comment = meta.description;
    categories = [ "Office" ];
    mimeTypes = [
      "application/xmind"
      "x-scheme-handler/xmind"
    ];
  };

  installPhase =
    let
      targetDir = if stdenv.hostPlatform.system == "i686-linux" then "XMind_i386" else "XMind_amd64";
    in
    ''
      mkdir -p $out/{bin,libexec/configuration/,share/{applications/,fonts/,icons/hicolor/scalable/apps/}}
      cp -r ${targetDir}/{configuration,p2,XMind{,.ini}} $out/libexec
      cp -r {plugins,features} $out/libexec/
      cp -r fonts $out/share/fonts/
      cp "${desktopItem}/share/applications/XMind.desktop" $out/share/applications/XMind.desktop
      cp ${srcIcon} $out/share/icons/hicolor/scalable/apps/xmind.png

      patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) \
        $out/libexec/XMind

      wrapProgram $out/libexec/XMind \
        --prefix LD_LIBRARY_PATH : "${libPath}"

      # Inspired by https://aur.archlinux.org/cgit/aur.git/tree/?h=xmind
      cat >$out/bin/XMind <<EOF
        #! ${runtimeShell}
        if [ ! -d "\$HOME/.xmind" ]; then
          mkdir -p "\$HOME/.xmind/configuration-cathy/"
          cp -r $out/libexec/configuration/ \$HOME/.xmind/configuration-cathy/
        fi

        exec "$out/libexec/XMind" "\$@"
      EOF
      chmod +x $out/bin/XMind

      ln -s ${jre8} $out/libexec/jre
    '';

  meta = with lib; {
    description = "Mind-mapping software";
    longDescription = ''
      XMind is a mind mapping and brainstorming software. In addition
      to the management elements, the software can capture ideas,
      clarify thinking, manage complex information, and promote team
      collaboration for higher productivity.

      It supports mind maps, fishbone diagrams, tree diagrams,
      organization charts, spreadsheets, etc. Normally, it is used for
      knowledge management, meeting minutes, task management, and
      GTD. Meanwhile, XMind can read FreeMind and MindManager files,
      and save to Evernote.
    '';
    homepage = "https://www.xmind.net/";
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    mainProgram = "XMind";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ michalrus ];
  };
}
