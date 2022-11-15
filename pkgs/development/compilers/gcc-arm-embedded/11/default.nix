{ lib
, stdenv
, fetchurl
, ncurses5
, python38
}:

stdenv.mkDerivation rec {
  pname = "gcc-arm-embedded";
  version = "11.3.rel1";

  platform = {
    aarch64-linux = "aarch64";
    x86_64-darwin = "darwin-x86_64";
    x86_64-linux  = "x86_64";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://developer.arm.com/-/media/Files/downloads/gnu/${version}/binrel/arm-gnu-toolchain-${version}-${platform}-arm-none-eabi.tar.xz";
    sha256 = {
      aarch64-linux = "0pmm5r0k5mxd5drbn2s8a7qkm8c4fi8j5y31c70yrp0qs08kqwbc";
      x86_64-darwin = "1kr9kd9p2xk84fa99zf3gz5lkww2i9spqkjigjwakfkzbva56qw2";
      x86_64-linux  = "08b1w1zmj4z80k59zmlc1bf34lg8d7z65fwvp5ir2pb1d1zxh86l";
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
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
  };
}
