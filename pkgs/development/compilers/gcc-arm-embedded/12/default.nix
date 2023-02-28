{ lib
, stdenv
, fetchurl
, ncurses5
, python38
}:

stdenv.mkDerivation rec {
  pname = "gcc-arm-embedded";
  version = "12.2.rel1";

  platform = {
    aarch64-darwin = "darwin-arm64";
    aarch64-linux  = "aarch64";
    x86_64-darwin  = "darwin-x86_64";
    x86_64-linux   = "x86_64";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://developer.arm.com/-/media/Files/downloads/gnu/${version}/binrel/arm-gnu-toolchain-${version}-${platform}-arm-none-eabi.tar.xz";
    sha256 = {
      aarch64-darwin = "0j12n631bmbfvnfbmv4q7cfhmh4l7ka3vcjcvyw0vjqb4msyia91";
      aarch64-linux  = "131ydgndff7dyhkivfchbk43lv3cv2p172knkqilx64aapvk5qvy";
      x86_64-darwin  = "00i9gd1ny00681pwinh6ng9x45xsyrnwc6hm2vr348z9gasyxh00";
      x86_64-linux   = "0rv8r5zh0a5621v0xygxi8f6932qgwinw2s9vnniasp9z7897gl4";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  dontConfigure = true;
  dontBuild = true;
  dontPatchELF = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out
    cp -r * $out
  '';

  preFixup = ''
    find $out -type f | while read f; do
      patchelf "$f" > /dev/null 2>&1 || continue
      patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) "$f" || true
      patchelf --set-rpath ${lib.makeLibraryPath [ "$out" stdenv.cc.cc ncurses5 python38 ]} "$f" || true
    done
  '';

  meta = with lib; {
    description = "Pre-built GNU toolchain from ARM Cortex-M & Cortex-R processors";
    homepage = "https://developer.arm.com/open-source/gnu-toolchain/gnu-rm";
    license = with licenses; [ bsd2 gpl2 gpl3 lgpl21 lgpl3 mit ];
    maintainers = with maintainers; [ prusnak ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
}
