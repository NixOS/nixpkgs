{ lib
, stdenv
, ncurses5
, python38
, libxcrypt-legacy
, runtimeShell
}:

stdenv.mkDerivation rec {
  pname = "gcc-arm-embedded";
  version = "11.3.rel1";

  platform = {
    aarch64-linux = "aarch64";
    x86_64-darwin = "darwin-x86_64";
    x86_64-linux = "x86_64";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  outputs = [ "out" "arm_none_eabi" ];

  src = builtins.fetchTarball {
    url = "https://developer.arm.com/-/media/Files/downloads/gnu/${version}/binrel/arm-gnu-toolchain-${version}-${platform}-arm-none-eabi.tar.xz";
    sha256 = {
      aarch64-linux = "0pmm5r0k5mxd5drbn2s8a7qkm8c4fi8j5y31c70yrp0qs08kqwbc";
      x86_64-darwin = "1kr9kd9p2xk84fa99zf3gz5lkww2i9spqkjigjwakfkzbva56qw2";
      x86_64-linux = "0zg754z0s8fx3qwh8jssf6rslnx9xmgcd2va6lykc8vlk8v5r19y";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;
  # this works, but automatic patchelf is run (and fails on 32-bit, relocatable files)
  # when running auditTmpdir. noAuditTmpdir disables it, but it's not a good idea.
  # This needs either a fix for patchelf or the script that feeds it the "wrong" ELF.
  dontPatchELF = true;

  installPhase = ''
    mkdir -p $out
    cp -r * $out
    # arm-none-eabi is a big boy and the complete outputs exceeds hydra's max_output_size.
    moveToOutput "arm-none-eabi" "$arm_none_eabi"
    # Link to it here in case anyone refers to it.
    ln -s "$arm_none_eabi" "$out/arm-none-eabi"

    # Wrap gdb with correct Python path.
    mv $out/bin/arm-none-eabi-gdb $out/bin/arm-none-eabi-gdb-unwrapped
    cat <<EOF > $out/bin/arm-none-eabi-gdb
      #!${runtimeShell}
      export PYTHONPATH=${python38}/lib/python3.8
      export PYTHONHOME=${python38}/bin/python3.8
      exec $out/bin/arm-none-eabi-gdb-unwrapped "\$@"
    EOF
    chmod +x $out/bin/arm-none-eabi-gdb
  '';

  # Fix rpath for pre-compiled native binaries.
  # WARNING: The target bineries in arm-none-eabi are not patched and may not work.
  preFixup = ''
    # We find all ELF files that are not for 32-bit (target files).
    # This package only serves 64 bit systems anyways.
    for f in $(find $out -type f -exec file {} \; | awk -F: '$2 ~ /ELF/ && ! /32-bit/ {print $1}'); do
      patchelf "$f" > /dev/null 2>&1 || continue
      patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) "$f" || true
      patchelf --set-rpath ${lib.makeLibraryPath [ "$out" stdenv.cc.cc ncurses5 python38 libxcrypt-legacy ]} "$f" || true
    done
  '';

  meta = with lib; {
    description = "Pre-built GNU toolchain from ARM Cortex-M & Cortex-R processors";
    homepage = "https://developer.arm.com/open-source/gnu-toolchain/gnu-rm";
    license = with licenses; [ bsd2 gpl2 gpl3 lgpl21 lgpl3 mit ];
    maintainers = with maintainers; [ prusnak ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
