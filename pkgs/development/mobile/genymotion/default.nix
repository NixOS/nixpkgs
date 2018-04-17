{ stdenv, requireFile, makeWrapper, which, zlib, libGL, glib, xorg, libxkbcommon
, xdg_utils
# For glewinfo
, libXmu, libXi, libXext }:

let
  packages = [
    stdenv.cc.cc zlib glib xorg.libX11 libxkbcommon libXmu libXi libXext libGL
  ];
  libPath = "${stdenv.lib.makeLibraryPath packages}";
in
stdenv.mkDerivation rec {
  name = "genymotion-${version}";
  version = "2.8.0";
  src = requireFile {
    url = https://www.genymotion.com/download/;
    name = "genymotion-${version}-linux_x64.bin";
    sha256 = "0lvfdlpmmsyq2i9gs4mf6a8fxkfimdr4rhyihqnfhjij3fzxz4lk";
  };

  buildInputs = [ makeWrapper which xdg_utils ];

  unpackPhase = ''
    mkdir -p phony-home $out/share/applications
    export HOME=$TMP/phony-home

    mkdir ${name}
    echo "y" | sh $src -d ${name}
    sourceRoot=${name}

    substitute phony-home/.local/share/applications/genymobile-genymotion.desktop \
      $out/share/applications/genymobile-genymotion.desktop --replace "$TMP/${name}" "$out/libexec"
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
        --set "LD_LIBRARY_PATH" "${libPath}"
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

  meta = {
    description = "Fast and easy Android emulation";
    longDescription = ''
      Genymotion is a relatively fast Android emulator which comes with
      pre-configured Android (x86 with OpenGL hardware acceleration) images,
      suitable for application testing.
     '';
    homepage = https://www.genymotion.com/;
    license = stdenv.lib.licenses.unfree;
    platforms = ["x86_64-linux"];
    maintainers = [ stdenv.lib.maintainers.puffnfresh ];
  };
}
