{ stdenv, fetchurl, ncurses5, python27 }:

stdenv.mkDerivation rec {
  name = "gcc-arm-embedded-${version}";
  version = "6-2017-q2-update";
  subdir = "6-2017q2";

  src =
    if stdenv.isLinux then
      fetchurl {
        url = "https://developer.arm.com/-/media/Files/downloads/gnu-rm/${subdir}/gcc-arm-none-eabi-${version}-linux.tar.bz2";
        sha256="1hvwi02mx34al525sngnl0cm7dkmzxfkb1brq9kvbv28wcplp3p6";
      }
    else if stdenv.isDarwin then
      fetchurl {
        url = "https://developer.arm.com/-/media/Files/downloads/gnu-rm/${subdir}/gcc-arm-none-eabi-${version}-mac.tar.bz2";
        sha256="0019ylpq4inq7p5gydpmc9m8ni72fz2csrjlqmgx1698998q0c3x";
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
    license = with stdenv.lib.licenses; [ bsd2 gpl2 gpl3 lgpl21 lgpl3 mit ];
    maintainers = with stdenv.lib.maintainers; [ vinymeuh ];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
