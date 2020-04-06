{ stdenv
, fetchurl
, ncurses5
, python27
}:

stdenv.mkDerivation rec {
  pname = "gcc-arm-embedded";
  version = "9-2019-q4-major";
  subdir = "9-2019q4/RC2.1";

  suffix = {
    aarch64-linux = "aarch64-linux";
    x86_64-darwin = "mac";
    x86_64-linux  = "x86_64-linux";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://developer.arm.com/-/media/Files/downloads/gnu-rm/${subdir}/gcc-arm-none-eabi-${version}-${suffix}.tar.bz2";
    sha256 = {
      aarch64-linux = "1f5b9309006737950b2218250e6bb392e2d68d4f1a764fe66be96e2a78888d83";
      x86_64-darwin = "1249f860d4155d9c3ba8f30c19e7a88c5047923cea17e0d08e633f12408f01f0";
      x86_64-linux  = "bcd840f839d5bf49279638e9f67890b2ef3a7c9c7a9b25271e83ec4ff41d177a";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

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

  meta = with stdenv.lib; {
    description = "Pre-built GNU toolchain from ARM Cortex-M & Cortex-R processors";
    homepage = "https://developer.arm.com/open-source/gnu-toolchain/gnu-rm";
    license = with licenses; [ bsd2 gpl2 gpl3 lgpl21 lgpl3 mit ];
    maintainers = with maintainers; [ prusnak ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
  };
}
