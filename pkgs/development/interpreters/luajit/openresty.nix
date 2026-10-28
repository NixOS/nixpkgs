{
  self,
  callPackage,
  fetchFromGitHub,
  fetchpatch2,
  applyPatches,
  stdenv,
  passthruFun,
}:

let
  version = "2.1-20260824";

  src = fetchFromGitHub {
    owner = "openresty";
    repo = "luajit2";
    tag = "v${version}";
    hash = "sha256-IynlDQOyjCr1C3qibLg3OJ9Qd/Rb5jzjy30ETKdKvFM=";
  };

  # upstream LuaJIT has no riscv64.
  # port submitted at https://github.com/openresty/luajit2/pull/236 same as Debian
  srcWithRiscv64Port = applyPatches {
    inherit src;
    patches = [
      (fetchpatch2 {
        url = "https://github.com/openresty/luajit2/compare/v2.1-20260824...ce14aff834d8d62220fc730a16042c52451f41cc.diff";
        hash = "sha256-VHDTUr7PWpthmhO3BokCbdL1cricAnX6BjZGTi1wr3Q=";
      })
    ];
  };
in
callPackage ./default.nix {
  inherit version;

  # default luaAttr would be luajit_2_1, the wrong interpreter for the lua package set
  luaAttr = "luajit_openresty";

  src = if stdenv.hostPlatform.isRiscV64 then srcWithRiscv64Port else src;

  extraMeta = {
    badPlatforms = [
      "loongarch64-linux" # See https://github.com/LuaJIT/LuaJIT/issues/1278
      # 64-bit POWER (LE and BE, either ELF ABI version on the latter) *is* supported, but ELFv1 powerpc64-linux has an
      # issue with memory allocation
      # https://github.com/openresty/luajit2/issues/258
      # Both BE ABI versions use the same double though, so would have to inspect stdenv to differentiate.
      "powerpc64-linux"
    ];
  };

  inherit self passthruFun;
}
