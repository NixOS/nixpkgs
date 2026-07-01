{
  self,
  callPackage,
  fetchFromGitHub,
  passthruFun,
}:

callPackage ./default.nix {
  # The patch version is the timestamp of the git commit,
  # obtain via `cat $(nix-build -A luajit_2_1.src)/.relver`
  version = "2.1.1774638290";

  src = fetchFromGitHub {
    owner = "LuaJIT";
    repo = "LuaJIT";
    rev = "fbb36bb6bfa88716a47c58bcf9ce9f2ef752abac";
    hash = "sha256-BqH66q38mJpIYJgPiSPt7I0B3VLBvuDRRTiMJ7ldkBI=";
  };

  inherit self passthruFun;
}
