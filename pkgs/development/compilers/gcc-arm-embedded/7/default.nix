{ stdenv
, fetchurl
, ncurses5
, python27
}:

stdenv.mkDerivation rec {
  pname = "gcc-arm-embedded";
  version = "7-2018-q2-update";
  subdir = "7-2018q2";

  suffix = {
    x86_64-darwin = "mac";
    x86_64-linux  = "linux";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://developer.arm.com/-/media/Files/downloads/gnu-rm/${subdir}/gcc-arm-none-eabi-${version}-${suffix}.tar.bz2";
    sha256 = {
      x86_64-darwin = "0nc7m0mpa39qyhfyydxkkyqm7spfc27xf6ygi2vd2aym4r9azi61";
      x86_64-linux  = "0sgysp3hfpgrkcbfiwkp0a7ymqs02khfbrjabm52b5z61sgi05xv";
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
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
