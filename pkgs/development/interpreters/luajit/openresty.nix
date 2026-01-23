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

  inherit self passthruFun;
}
