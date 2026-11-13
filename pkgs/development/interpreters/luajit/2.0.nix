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
  version = "2.0.1791886455";

  src = fetchFromGitHub {
    owner = "LuaJIT";
    repo = "LuaJIT";
    rev = "acf8fcbd932a68d130fa3e3654e1b622e10fd6af";
    hash = "sha256-nol/3bLNUf3H2O0zk13Pi2NPbsMdStNvxvGXoZHPWZc=";
  };

  extraMeta = {
    # this isn't precise but it at least stops the useless Hydra build
    platforms = lib.filter (p: !lib.hasPrefix "aarch64-" p) (
      lib.platforms.linux ++ lib.platforms.darwin
    );
  };
  inherit self passthruFun;
}
