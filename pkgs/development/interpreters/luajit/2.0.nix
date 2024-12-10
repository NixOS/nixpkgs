{
  self,
  callPackage,
  fetchFromGitHub,
  lib,
  passthruFun,
}:

callPackage ./default.nix rec {
  # The patch version is the timestamp of the git commit,
  # obtain via `cat $(nix-build -A luajit_2_0.src)/.relver`
  version = "2.0.1693340858";

  src = fetchFromGitHub {
    owner = "LuaJIT";
    repo = "LuaJIT";
    rev = "c6ee7e19d107b4f9a140bb2ccf99162e26318c69";
    hash = "sha256-3/7ASZRniytw5RkOy0F9arHkZevq6dxmya+Ba3A5IIA=";
  };

  extraMeta = {
    # this isn't precise but it at least stops the useless Hydra build
    platforms = with lib; filter (p: !hasPrefix "aarch64-" p) (platforms.linux ++ platforms.darwin);
  };
  inherit self passthruFun;
}
