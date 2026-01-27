{
  self,
  callPackage,
  fetchFromGitHub,
  passthruFun,
}:

(callPackage ./default.nix {
  version = "2.1.1765228720";

  # https://github.com/koreader/koreader-base/tree/master/thirdparty/luajit
  src = fetchFromGitHub {
    owner = "LuaJIT";
    repo = "LuaJIT";
    rev = "7152e15489d2077cd299ee23e3d51a4c599ab14f";
    hash = "sha256-9nqv4t8bAFJSqSH0L3GpEjHiHjQDmGgjZzko7yH2sB8=";
  };

  inherit self passthruFun;
}).overrideAttrs
  (old: {
    patches = [
      ./koreader-luajit-enable-table_pack.patch
    ];
  })
