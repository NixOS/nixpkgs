{
  self,
  callPackage,
  fetchFromGitHub,
  passthruFun,
}:

callPackage ./default.nix {
  # The patch version is the timestamp of the git commit,
  # obtain via `cat $(nix-build -A luajit_2_1.src)/.relver`
  version = "2.1.1741730670";

  src = fetchFromGitHub {
    owner = "LuaJIT";
    repo = "LuaJIT";
    rev = "538a82133ad6fddfd0ca64de167c4aca3bc1a2da";
    hash = "sha256-3DhNqVdojsWDo8mKJXIyTqFODIiKzThcAzHPdnoJaVM=";
  };

  inherit self passthruFun;
}
