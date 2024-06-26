{
  lib,
  stdenv,
  fetchurl,
  ncurses5,
  python39,
  libxcrypt-legacy,
  runtimeShell,
}:

stdenv.mkDerivation rec {
  pname = "gcc-arm-embedded";
  version = "13.2.rel1";

  platform =
    {
      aarch64-darwin = "darwin-arm64";
      aarch64-linux = "aarch64";
      x86_64-darwin = "darwin-x86_64";
      x86_64-linux = "x86_64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://developer.arm.com/-/media/Files/downloads/gnu/${version}/binrel/arm-gnu-toolchain-${version}-${platform}-arm-none-eabi.tar.xz";
    sha256 =
      {
        aarch64-darwin = "39c44f8af42695b7b871df42e346c09fee670ea8dfc11f17083e296ea2b0d279";
        aarch64-linux = "8fd8b4a0a8d44ab2e195ccfbeef42223dfb3ede29d80f14dcf2183c34b8d199a";
        x86_64-darwin = "075faa4f3e8eb45e59144858202351a28706f54a6ec17eedd88c9fb9412372cc";
        x86_64-linux = "6cd1bbc1d9ae57312bcd169ae283153a9572bd6a8e4eeae2fedfbc33b115fdbb";
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
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
      patchelf --set-rpath ${
        lib.makeLibraryPath [
          "$out"
          stdenv.cc.cc
          ncurses5
          python39
          libxcrypt-legacy
        ]
      } "$f" || true
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
    license = with licenses; [
      bsd2
      gpl2
      gpl3
      lgpl21
      lgpl3
      mit
    ];
    maintainers = with maintainers; [
      prusnak
      prtzl
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
