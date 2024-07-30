{
  lib,
  callPackage,
  pname,
  version,
  zig,
}:
{
  passthru = {
    isBootstrap = lib.hasSuffix "-bootstrap" pname;
    hook = callPackage ./hook.nix { inherit zig; };
    cc = callPackage ./cc.nix { inherit zig; };
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
