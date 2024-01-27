{ self, callPackage, fetchFromGitHub, passthruFun }:

callPackage ./default.nix rec {
  version = "2.1-20220915";

  src = fetchFromGitHub {
    owner = "openresty";
    repo = "luajit2";
    rev = "v${version}";
    hash = "sha256-kMHE4iQtm2CujK9TVut1jNhY2QxYP514jfBsxOCyd4s=";
  };

  inherit self passthruFun;
}
