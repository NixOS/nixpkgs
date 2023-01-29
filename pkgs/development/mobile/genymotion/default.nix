{ stdenv, lib, fetchurl, makeWrapper, which, zlib, libGL, glib, xorg, libxkbcommon
, xdg-utils, libXrender, fontconfig, freetype, systemd, libpulseaudio
# For glewinfo
, libXmu, libXi, libXext }:

let
  packages = [
    stdenv.cc.cc
    zlib
    glib
    xorg.libX11
    libxkbcommon
    libXmu
    libXi
    libXext
    libGL
    libXrender
    fontconfig
    freetype
    systemd
    libpulseaudio
  ];
  libPath = lib.makeLibraryPath packages;
in
stdenv.mkDerivation rec {
  pname = "genymotion";
  version = "3.2.1";
  src = fetchurl {
    url = "https://dl.genymotion.com/releases/genymotion-${version}/genymotion-${version}-linux_x64.bin";
    name = "genymotion-${version}-linux_x64.bin";
    sha256 = "sha256-yCczUfiMcuu9OauMDmMdtnheDBXiC9tOEu0cWAW95FM=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ which xdg-utils ];

  unpackPhase = ''
    mkdir -p phony-home $out/share/applications
    export HOME=$TMP/phony-home

    mkdir ${pname}
    echo "y" | sh $src -d ${pname}
    sourceRoot=${pname}

    substitute phony-home/.local/share/applications/genymobile-genymotion.desktop \
      $out/share/applications/genymobile-genymotion.desktop --replace "$TMP/${pname}" "$out/libexec"
  '';

  installPhase = ''
    mkdir -p $out/bin $out/libexec
    mv genymotion $out/libexec/
    ln -s $out/libexec/genymotion/{genymotion,player} $out/bin
  '';

  fixupPhase = ''
    patchInterpreter() {
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        "$out/libexec/genymotion/$1"
    }

    patchExecutable() {
      patchInterpreter "$1"
      wrapProgram "$out/libexec/genymotion/$1" \
        --set "LD_LIBRARY_PATH" "${libPath}" \
        --unset "QML2_IMPORT_PATH"
    }

    patchTool() {
      patchInterpreter "tools/$1"
      wrapProgram "$out/libexec/genymotion/tools/$1" \
        --set "LD_LIBRARY_PATH" "${libPath}"
    }

    patchExecutable genymotion
    patchExecutable player

    patchTool adb
    patchTool aapt
    patchTool glewinfo

    rm $out/libexec/genymotion/libxkbcommon*
  '';

  meta = with lib; {
    description = "Fast and easy Android emulation";
    longDescription = ''
      Genymotion is a relatively fast Android emulator which comes with
      pre-configured Android (x86 with OpenGL hardware acceleration) images,
      suitable for application testing.
     '';
    homepage = "https://www.genymotion.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = ["x86_64-linux"];
    maintainers = [ maintainers.puffnfresh ];
  };
}
