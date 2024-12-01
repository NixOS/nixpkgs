{ self, callPackage, fetchFromGitHub, passthruFun }:

callPackage ./default.nix {
  # The patch version is the timestamp of the git commit,
  # obtain via `cat $(nix-build -A luajit_2_1.src)/.relver`
  version = "2.1.1713773202";

  src = fetchFromGitHub {
    owner = "LuaJIT";
    repo = "LuaJIT";
    rev = "5790d253972c9d78a0c2aece527eda5b134bbbf7";
    hash = "sha256-WG8AWDI182/9O7NrZlQ6ZH/esyYE2pWXMuSzWUuntSA=";
  };

  inherit self passthruFun;
}
