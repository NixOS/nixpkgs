{
  self,
  callPackage,
  fetchFromGitHub,
  lib,
  passthruFun,
}:

callPackage ./default.nix {
  # The patch version is the timestamp of the git commit,
  # obtain via `cat $(nix-build -A luajit_2_0.src)/.relver`
  version = "2.0.1741557863";

  src = fetchFromGitHub {
    owner = "LuaJIT";
    repo = "LuaJIT";
    rev = "85c3f2fb6f59276ebf07312859a69d6d5a897f62";
    hash = "sha256-5UIZ650M/0W08iX1ajaHvDbNgjbzZJ1akVwNbiDUeyY=";
  };

  extraMeta = {
    # this isn't precise but it at least stops the useless Hydra build
    platforms = lib.filter (p: !lib.hasPrefix "aarch64-" p) (
      lib.platforms.linux ++ lib.platforms.darwin
    );
  };
  inherit self passthruFun;
}
