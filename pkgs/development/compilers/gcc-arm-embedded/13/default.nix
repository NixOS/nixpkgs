{ lib
, stdenv
, fetchurl
, ncurses5
, python39
, libxcrypt-legacy
, runtimeShell
}:

stdenv.mkDerivation rec {
  pname = "gcc-arm-embedded";
  version = "13.3.rel1";

  platform = {
    aarch64-darwin = "darwin-arm64";
    aarch64-linux  = "aarch64";
    x86_64-darwin  = "darwin-x86_64";
    x86_64-linux   = "x86_64";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://developer.arm.com/-/media/Files/downloads/gnu/${version}/binrel/arm-gnu-toolchain-${version}-${platform}-arm-none-eabi.tar.xz";
    # hashes obtained from location ${url}.sha256asc
    sha256 = {
      aarch64-darwin = "fb6921db95d345dc7e5e487dd43b745e3a5b4d5c0c7ca4f707347148760317b4";
      aarch64-linux  = "c8824bffd057afce2259f7618254e840715f33523a3d4e4294f471208f976764";
      x86_64-darwin  = "1ab00742d1ed0926e6f227df39d767f8efab46f5250505c29cb81f548222d794";
      x86_64-linux   = "95c011cee430e64dd6087c75c800f04b9c49832cc1000127a92a97f9c8d83af4";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  dontConfigure = true;
  dontBuild = true;
  dontPatchELF = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out
    cp -r * $out
  '';

  preFixup = ''
    find $out -type f | while read f; do
      patchelf "$f" > /dev/null 2>&1 || continue
      patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) "$f" || true
      patchelf --set-rpath ${lib.makeLibraryPath [ "$out" stdenv.cc.cc ncurses5 python39 libxcrypt-legacy ]} "$f" || true
    done
  '';

  postFixup = ''
    mv $out/bin/arm-none-eabi-gdb $out/bin/arm-none-eabi-gdb-unwrapped
    cat <<EOF > $out/bin/arm-none-eabi-gdb
    #!${runtimeShell}
    export PYTHONPATH=${python39}/lib/python3.9
    export PYTHONHOME=${python39.interpreter}
    exec $out/bin/arm-none-eabi-gdb-unwrapped "\$@"
    EOF
    chmod +x $out/bin/arm-none-eabi-gdb
  '';

  meta = with lib; {
    description = "Pre-built GNU toolchain from ARM Cortex-M & Cortex-R processors";
    homepage = "https://developer.arm.com/open-source/gnu-toolchain/gnu-rm";
    license = with licenses; [ bsd2 gpl2 gpl3 lgpl21 lgpl3 mit ];
    maintainers = with maintainers; [ prusnak prtzl ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
