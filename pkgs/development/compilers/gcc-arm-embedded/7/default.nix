{ stdenv, fetchurl, ncurses5, python27 }:

stdenv.mkDerivation rec {
  name = "gcc-arm-embedded-${version}";
  version = "7-2017-q4-major";
  subdir = "7-2017q4";

  platformString =
    if stdenv.isLinux then "linux"
    else if stdenv.isDarwin then "mac"
    else throw "unsupported platform";

  urlString = "https://developer.arm.com/-/media/Files/downloads/gnu-rm/${subdir}/gcc-arm-none-eabi-${version}-${platformString}.tar.bz2";

  src =
    if stdenv.isLinux then fetchurl { url=urlString; sha256="0slswspjsk3f130ikfhqmf704qq4ljg317m6x88142hkmvi2k84n"; }
    else if stdenv.isDarwin then fetchurl { url=urlString; sha256="1jywgylr9f3idr9ll22hpiqmnfqivkj6f05nnl8ci485rz3pddw9"; }
    else throw "unsupported platform";

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
    license = with stdenv.lib.licenses; [ bsd2 gpl2 gpl3 lgpl21 lgpl3 mit ];
    maintainers = with stdenv.lib.maintainers; [ vinymeuh ];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
