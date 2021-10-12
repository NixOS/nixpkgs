{ lib
, stdenv
, fetchurl
, ncurses5
, python27
}:

stdenv.mkDerivation rec {
  pname = "gcc-arm-embedded";
  version = "8.3.1";
  release = "8-2019-q3-update";
  subdir = "8-2019q3/RC1.1";

  suffix = {
    x86_64-darwin = "mac";
    x86_64-linux  = "linux";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://developer.arm.com/-/media/Files/downloads/gnu-rm/${subdir}/gcc-arm-none-eabi-${release}-${suffix}.tar.bz2";
    sha256 = {
      x86_64-darwin = "fc235ce853bf3bceba46eff4b95764c5935ca07fc4998762ef5e5b7d05f37085";
      x86_64-linux  = "b50b02b0a16e5aad8620e9d7c31110ef285c1dde28980b1a9448b764d77d8f92";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  dontConfigure = true;
  dontBuild = true;
  dontPatchELF = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out
    cp -r * $out
    ln -s $out/share/doc/gcc-arm-none-eabi/man $out/man
  '';

  preFixup = ''
    find $out -type f | while read f; do
      patchelf "$f" > /dev/null 2>&1 || continue
      patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) "$f" || true
      patchelf --set-rpath ${lib.makeLibraryPath [ "$out" stdenv.cc.cc ncurses5 python27 ]} "$f" || true
    done
  '';

  meta = with lib; {
    description = "Pre-built GNU toolchain from ARM Cortex-M & Cortex-R processors";
    homepage = "https://developer.arm.com/open-source/gnu-toolchain/gnu-rm";
    license = with licenses; [ bsd2 gpl2 gpl3 lgpl21 lgpl3 mit ];
    maintainers = with maintainers; [ prusnak ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
