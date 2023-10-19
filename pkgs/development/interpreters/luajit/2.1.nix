{ self, callPackage, fetchFromGitHub, passthruFun }:

callPackage ./default.nix rec {
  # The patch version is the timestamp of the git commit,
  # obtain via `cat $(nix-build -A luajit_2_1.src)/.relver`
  version = "2.1.1693350652";

  src = fetchFromGitHub {
    owner = "LuaJIT";
    repo = "LuaJIT";
    rev = "41fb94defa8f830ce69a8122b03f6ac3216d392a";
    hash = "sha256-iY80CA97RqJ9gF1Kl7ms/lC6m6KScjxWmljh5Gy7Brg=";
  };

  inherit self passthruFun;
}
