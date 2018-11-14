{ stdenv, lib, fetchurl, ncurses5, python27 }:

with lib;

stdenv.mkDerivation rec {
  name = "gcc-arm-embedded-${version}";
  version = "7-2018-q2-update";
  subdir = "7-2018q2";

  urlString = "https://developer.arm.com/-/media/Files/downloads/gnu-rm/${subdir}/gcc-arm-none-eabi-${version}-linux.tar.bz2";

  src = fetchurl { url=urlString; sha256="0sgysp3hfpgrkcbfiwkp0a7ymqs02khfbrjabm52b5z61sgi05xv"; };

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p $out
    cp -r * $out
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
