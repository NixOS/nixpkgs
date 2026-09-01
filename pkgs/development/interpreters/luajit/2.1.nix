{
  self,
  callPackage,
  fetchFromGitHub,
  passthruFun,
}:

callPackage ./default.nix {
  # The patch version is the timestamp of the git commit,
  # obtain via `cat $(nix-build -A luajit_2_1.src)/.relver`
  version = "2.1.1785763465";

  src = fetchFromGitHub {
    owner = "LuaJIT";
    repo = "LuaJIT";
    rev = "1edc3e52b67eaf6ce5f809be8e17d6862594b8bc";
    hash = "sha256-mcOvVJ7AaoHrbEXxznpOkFoY7Kbd2aWMoOmyx5B4FIg=";
  };

  inherit self passthruFun;
}
