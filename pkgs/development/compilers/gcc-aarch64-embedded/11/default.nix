{ lib
, stdenv
, fetchurl
, ncurses5
, python38
}:

stdenv.mkDerivation rec {
  pname = "gcc-aarch64-embedded";
  version = "11.3.rel1";

  platform = {
    aarch64-linux = "aarch64";
    x86_64-darwin = "darwin-x86_64";
    x86_64-linux  = "x86_64";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://developer.arm.com/-/media/Files/downloads/gnu/${version}/binrel/arm-gnu-toolchain-${version}-${platform}-aarch64-none-elf.tar.xz";
    hash = {
      aarch64-linux = "sha256-xe09gSOhr9Z99Zt95SC5GgruzXW3CLp1fHBvy0gj6Fo=";
      x86_64-darwin = "sha256-y47lDfHVQTXcDleheH7ajAkPpVYaqiD8vMBUjfuNzrI=";
      x86_64-linux  = "sha256-+55WKpDeGzopYblSGTwcZSCHKqFILApeCreZcOxudpA=";
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
    description = "Pre-built GNU toolchain from aarch64 Cortex-A & Cortex-R processors";
    homepage = "https://developer.arm.com/open-source/gnu-toolchain/gnu-rm";
    license = with licenses; [ bsd2 gpl2 gpl3 lgpl21 lgpl3 mit ];
    maintainers = with maintainers; [ newam ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
  };
}
