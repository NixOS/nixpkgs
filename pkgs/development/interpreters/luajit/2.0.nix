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
  version = "2.0.1774896119";

  src = fetchFromGitHub {
    owner = "LuaJIT";
    repo = "LuaJIT";
    rev = "e4c7d8b38040518d42599eef8ddb5e67aa967a9c";
    hash = "sha256-nioJxKo6msQQTP4skMEFDh6xD2cekOEXbMRFus73XuI=";
  };

  extraMeta = {
    # this isn't precise but it at least stops the useless Hydra build
    platforms = lib.filter (p: !lib.hasPrefix "aarch64-" p) (
      lib.platforms.linux ++ lib.platforms.darwin
    );
  };
  inherit self passthruFun;
}
