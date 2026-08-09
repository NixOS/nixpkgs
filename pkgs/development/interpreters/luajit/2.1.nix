{
  self,
  callPackage,
  fetchFromGitHub,
  passthruFun,
}:

callPackage ./default.nix {
  # The patch version is the timestamp of the git commit,
  # obtain via `cat $(nix-build -A luajit_2_1.src)/.relver`
  version = "2.1.1785577137";

  src = fetchFromGitHub {
    owner = "LuaJIT";
    repo = "LuaJIT";
    rev = "4886b676a698acc4bbdf54adfabb3e33a8c020e8";
    hash = "sha256-3nTyPcphBQN2segb5bxBgvrWHodN/ckRy4AGS8lDL44=";
  };

  inherit self passthruFun;
}
