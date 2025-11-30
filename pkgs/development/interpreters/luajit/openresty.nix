{
  self,
  callPackage,
  fetchFromGitHub,
  passthruFun,
}:

callPackage ./default.nix rec {
  version = "2.1-20250826";

  src = fetchFromGitHub {
    owner = "openresty";
    repo = "luajit2";
    rev = "v${version}";
    hash = "sha256-fF3xgAy2IjFy4LdXPlk4RuX+IclOXaw3YR24wyMBNgM=";
  };

  inherit self passthruFun;
}
