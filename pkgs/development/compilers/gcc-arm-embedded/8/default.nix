{ stdenv, lib, fetchurl, ncurses5, python27 }:

with lib;

stdenv.mkDerivation rec {
  pname = "gcc-arm-embedded";
  version = "8-2019-q3-update";
  subdir = "8-2019q3/RC1.1";

  src =
  if stdenv.isLinux then
    fetchurl {
      url = "https://developer.arm.com/-/media/Files/downloads/gnu-rm/${subdir}/gcc-arm-none-eabi-${version}-linux.tar.bz2";
      sha256="b50b02b0a16e5aad8620e9d7c31110ef285c1dde28980b1a9448b764d77d8f92";
    }
  else if stdenv.isDarwin then
    fetchurl {
      url = "https://developer.arm.com/-/media/Files/downloads/gnu-rm/${subdir}/gcc-arm-none-eabi-${version}-mac.tar.bz2";
      sha256="fc235ce853bf3bceba46eff4b95764c5935ca07fc4998762ef5e5b7d05f37085";
    }
  else throw "unsupported platform";

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p $out
    cp -r * $out
    ln -s $out/share/doc/gcc-arm-none-eabi/man $out/man
  '';

  dontPatchELF = true;
  dontStrip = true;

  preFixup = ''
    find $out -type f | while read f; do
      patchelf $f > /dev/null 2>&1 || continue
      patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) "$f" || true
      patchelf --set-rpath ${stdenv.lib.makeLibraryPath [ "$out" stdenv.cc.cc ncurses5 python27 ]} "$f" || true
    done
  '';

  meta = {
    description = "Pre-built GNU toolchain from ARM Cortex-M & Cortex-R processors (Cortex-M0/M0+/M3/M4/M7, Cortex-R4/R5/R7/R8)";
    homepage = https://developer.arm.com/open-source/gnu-toolchain/gnu-rm;
    license = with licenses; [ bsd2 gpl2 gpl3 lgpl21 lgpl3 mit ];
    maintainers = with maintainers; [ prusnak ];
    platforms = platforms.linux;
  };
}
