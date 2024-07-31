{
  lib,
  wrapCCWith,
  wrapBintoolsWith,
  makeWrapper,
  stdenv,
  runCommand,
  stdenv,
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
        for tool in cc c++; do
          makeWrapper "$zig/bin/zig" "$out/bin/$tool" \
            --add-flags "$tool" \
            --run "export ZIG_GLOBAL_CACHE_DIR=\$(mktemp -d)"
        done

        mv $out/bin/c++ $out/bin/clang++
        mv $out/bin/cc $out/bin/clang
      '';

  bintools =
    let
      targetPrefix = lib.optionalString (
        stdenv.hostPlatform != stdenv.targetPlatform
      ) "${stdenv.targetPlatform.config}-";
    in
    wrapBintoolsWith {
      bintools =
        runCommand "zig-bintools-${zig.version}"
          {
            pname = "zig-bintools";
            inherit (zig) version meta;

            nativeBuildInputs = [ makeWrapper ];

            passthru = {
              isZig = true;
              inherit targetPrefix;
            };

            inherit zig;
          }
          ''
            mkdir -p $out/bin
            for tool in ar objcopy; do
              makeWrapper "$zig/bin/zig" "$out/bin/${targetPrefix}-$tool" \
                --add-flags "$tool" \
                --run "export ZIG_GLOBAL_CACHE_DIR=\$(mktemp -d)"
            done
          '';
    };

  nixSupport.cc-cflags =
    [
      "-target"
      "${stdenv.targetPlatform.parsed.cpu.name}-${stdenv.targetPlatform.parsed.kernel.name}-${stdenv.targetPlatform.parsed.abi.name}"
    ]
    ++ lib.optional (
      stdenv.targetPlatform.isLinux && !(targetPackages.isStatic or false)
    ) "-Wl,-dynamic-linker=${targetPackages.stdenv.cc.bintools.dynamicLinker}";
}
