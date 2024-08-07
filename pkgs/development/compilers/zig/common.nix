{
  lib,
  callPackage,
  pname,
  version,
  zig,
  targetPackages,
  targetPlatform,
  runCommandNoCC,
  wrapBintoolsWith,
  wrapCCWith,
}:
{
  passthru = {
    isBootstrap = lib.hasSuffix "-bootstrap" pname;
    hook = callPackage ./hook.nix { inherit zig; };

    bintools-unwrapped = callPackage ./bintools.nix { inherit zig runCommandNoCC; };
    bintools = wrapBintoolsWith { bintools = zig.bintools-unwrapped; };

    cc-unwrapped = callPackage ./cc.nix { inherit zig runCommandNoCC; };
    cc = wrapCCWith {
      cc = zig.cc-unwrapped;
      bintools = zig.bintools;
      nixSupport.cc-cflags =
        [
          "-target"
          "${targetPlatform.parsed.cpu.name}-${targetPlatform.parsed.kernel.name}-${targetPlatform.parsed.abi.name}"
        ]
        ++ lib.optional (
          targetPlatform.isLinux && !(targetPackages.isStatic or false)
        ) "-Wl,-dynamic-linker=${targetPackages.stdenv.cc.bintools.dynamicLinker}";
    };

    stdenv = callPackage ./stdenv.nix { inherit zig; };
  };

  meta = {
    description = "General-purpose programming language and toolchain for maintaining robust, optimal, and reusable software";
    homepage = "https://ziglang.org/";
    changelog = "https://ziglang.org/download/${version}/release-notes.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ andrewrk ] ++ lib.teams.zig.members;
    mainProgram = "zig";
    platforms = lib.platforms.unix;
  };
}
