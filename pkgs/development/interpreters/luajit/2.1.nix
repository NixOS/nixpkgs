{
  self,
  callPackage,
  fetchFromGitHub,
  passthruFun,
}:

callPackage ./default.nix {
  # The patch version is the timestamp of the git commit,
  # obtain via `cat $(nix-build -A luajit_2_1.src)/.relver`
  version = "2.1.1791890110";

  src = fetchFromGitHub {
    owner = "LuaJIT";
    repo = "LuaJIT";
    rev = "634daf2453559fd5e0ec282f3b7aedaa09e9f344";
    hash = "sha256-vIT7ShP1cxxhZr9/vXcNsc0nhYzjncpzLFYXDG2Ff6I=";
  };

  inherit self passthruFun;
}
