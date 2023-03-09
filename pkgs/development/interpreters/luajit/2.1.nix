{ self, callPackage, fetchFromGitHub, passthruFun }:

callPackage ./default.nix {
  version = "2.1.0-2022-10-04";

  src = fetchFromGitHub {
    owner = "LuaJIT";
    repo = "LuaJIT";
    rev = "6c4826f12c4d33b8b978004bc681eb1eef2be977";
    hash = "sha256-GMgoSVHrfIuLdk8mW9XgdemNFsAkkQR4wiGGjaAXAKg=";
  };

  inherit self passthruFun;
}
