{ lib
, stdenv
, fetchurl
, ncurses5
, python27
}:

stdenv.mkDerivation rec {
  pname = "gcc-arm-embedded";
  version = "10.3.1";
  release = "10.3-2021.07";

  suffix = {
    aarch64-linux = "aarch64-linux";
    x86_64-darwin = "mac-10.14.6";
    x86_64-linux  = "x86_64-linux";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://developer.arm.com/-/media/Files/downloads/gnu-rm/${release}/gcc-arm-none-eabi-${release}-${suffix}.tar.bz2";
    sha256 = {
      aarch64-linux = "0y4nyrff5bq90v44z2h90gqgl18bs861i9lygx4z89ym85jycx9s";
      x86_64-darwin = "1r3yidmgx1xq1f19y2c5njf2g95vs9cssmmsxsb68qm192r58i8a";
      x86_64-linux  = "1skcalz1sr0hhpjcl8qjsqd16n2w0zrbnlrbr8sx0g728kiqsnwc";
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
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
  };
}
