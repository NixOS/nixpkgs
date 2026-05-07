{
  self,
  callPackage,
  fetchFromGitHub,
  passthruFun,
}:

callPackage ./default.nix rec {
  version = "2.1-20251030";

  src = fetchFromGitHub {
    owner = "openresty";
    repo = "luajit2";
    rev = "v${version}";
    hash = "sha256-SICmM+/dvp/36UAWAH0l7D938iFDimnoKBOjlOodrCY=";
  };

  extraMeta = {
    badPlatforms = [
      "loongarch64-linux" # See https://github.com/LuaJIT/LuaJIT/issues/1278
      "riscv64-linux" # See https://github.com/LuaJIT/LuaJIT/issues/628
      # 64-bit POWER (LE and BE, either ELF ABI version on the latter) *is* supported, but ELFv1 powerpc64-linux has an
      # issue with memory allocation
      # https://github.com/openresty/luajit2/issues/258
      # Both BE ABI versions use the same double though, so would have to inspect stdenv to differentiate.
      "powerpc64-linux"
    ];
  };

  inherit self passthruFun;
}
