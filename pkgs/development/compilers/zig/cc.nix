{
  lib,
  wrapCCWith,
  makeWrapper,
  runCommand,
  targetPlatform,
  targetPackages,
  zig,
}:
wrapCCWith {
  cc =
    runCommand "zig-cc-${zig.version}"
      {
        pname = "zig-cc";
        inherit (zig) version meta;

        nativeBuildInputs = [ makeWrapper ];

        passthru.isZig = true;
        inherit zig;
      }
      ''
        mkdir -p $out/bin
        for tool in ar cc c++ objcopy; do
          makeWrapper "$zig/bin/zig" "$out/bin/$tool" \
            --add-flags "$tool" \
            --run "export ZIG_GLOBAL_CACHE_DIR=\$(mktemp -d)"
        done

        mv $out/bin/c++ $out/bin/clang++
        mv $out/bin/cc $out/bin/clang
      '';

  nixSupport.cc-cflags =
    [
      "-target"
      "${targetPlatform.parsed.cpu.name}-${targetPlatform.parsed.kernel.name}-${targetPlatform.parsed.abi.name}"
    ]
    ++ lib.optional (
      targetPlatform.isLinux && !(targetPackages.isStatic or false)
    ) "-Wl,-dynamic-linker=${targetPackages.stdenv.cc.bintools.dynamicLinker}";
}
