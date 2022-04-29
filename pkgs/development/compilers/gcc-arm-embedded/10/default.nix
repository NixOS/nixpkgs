{ lib
, stdenv
, fetchurl
, ncurses5
, python27
}:

stdenv.mkDerivation rec {
  pname = "gcc-arm-embedded";
  version = "10.3.1";
  release = "10.3-2021.10";

  suffix = {
    aarch64-darwin = "mac";  # use intel binaries via rosetta
    aarch64-linux = "aarch64-linux";
    x86_64-darwin = "mac";
    x86_64-linux  = "x86_64-linux";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://developer.arm.com/-/media/Files/downloads/gnu-rm/${release}/gcc-arm-none-eabi-${release}-${suffix}.tar.bz2";
    sha256 = {
      aarch64-darwin = "0fr8pki2g4bfk1rk90dzwql37d0b71ngzs9zyx0g2jainan3sqgv";
      aarch64-linux = "020j8gkzc0i0b74vz98gvngnwjm5222j1gk5nswfk6587krba1gn";
      x86_64-darwin = "0fr8pki2g4bfk1rk90dzwql37d0b71ngzs9zyx0g2jainan3sqgv";
      x86_64-linux  = "18y92vpl22hf74yqdvmpw8adrkl92s4crzzs6avm05md37qb9nwp";
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
