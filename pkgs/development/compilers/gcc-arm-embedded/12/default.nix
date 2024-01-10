{ lib
, stdenv
, fetchurl
, ncurses5
, python38
, libxcrypt-legacy
, runtimeShell
}:

stdenv.mkDerivation rec {
  pname = "gcc-arm-embedded";
  version = "12.3.rel1";

  platform = {
    aarch64-darwin = "darwin-arm64";
    aarch64-linux  = "aarch64";
    x86_64-darwin  = "darwin-x86_64";
    x86_64-linux   = "x86_64";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://developer.arm.com/-/media/Files/downloads/gnu/${version}/binrel/arm-gnu-toolchain-${version}-${platform}-arm-none-eabi.tar.xz";
    sha256 = {
      aarch64-darwin = "sha256-Oy7uC99xwbvrPDt0JPv3vZ1cPw9aOkp4FZyeOtIZ570=";
      aarch64-linux  = "sha256-FMBIfVdT9gcdJOVoiB98fmf4DdgxZd7FFks3MTlK9DE=";
      x86_64-darwin  = "sha256-5u2L+TD62c4z4SCrkLNpV7H3efzKpt5snKmliYLAQpE=";
      x86_64-linux   = "sha256-EqKBVkQxjrzOr4S+q7Zl0JJLbnniEEhFLFMxpWMyswk=";
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
      patchelf --set-rpath ${lib.makeLibraryPath [ "$out" stdenv.cc.cc ncurses5 python38 libxcrypt-legacy ]} "$f" || true
    done
  '';

  postFixup = ''
    mv $out/bin/arm-none-eabi-gdb $out/bin/arm-none-eabi-gdb-unwrapped
    cat <<EOF > $out/bin/arm-none-eabi-gdb
    #!${runtimeShell}
    export PYTHONPATH=${python38}/lib/python3.8
    export PYTHONHOME=${python38}/bin/python3.8
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
