{ lib
, stdenv
, fetchurl
, ncurses5
, python27
}:

stdenv.mkDerivation rec {
  pname = "gcc-arm-embedded";
  version = "9.3.1";
  release = "9-2020-q2-update";
  subdir = "9-2020q2";

  suffix = {
    aarch64-darwin = "mac";  # use intel binaries via rosetta
    aarch64-linux = "aarch64-linux";
    x86_64-darwin = "mac";
    x86_64-linux  = "x86_64-linux";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://developer.arm.com/-/media/Files/downloads/gnu-rm/${subdir}/gcc-arm-none-eabi-${release}-${suffix}.tar.bz2";
    sha256 = {
      aarch64-darwin = "1ils9z16wrvglh72m428y5irmd36biq79yj86756whib8izbifdv";
      aarch64-linux = "1b5q2y710hy7lddj8vj3zl54gfl74j30kx3hk3i81zrcbv16ah8z";
      x86_64-darwin = "1ils9z16wrvglh72m428y5irmd36biq79yj86756whib8izbifdv";
      x86_64-linux  = "07zi2yr5gvhpbij5pnj49zswb9g2gw7zqp4xwwniqmq477h2xp2s";
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
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
}
