{ pkgs, lib, fetchFromGitHub, leveldb, ... }:

{
  pname = "gerbil-leveldb";
  version = "unstable-2023-09-23";
  git-version = "c62e47f";
  gerbil-package = "clan";
  gerbilInputs = [ ];
  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [ leveldb ];
  version-path = "";
  softwareName = "Gerbil-LevelDB";

  pre-src = {
    fun = fetchFromGitHub;
    owner = "mighty-gerbils";
    repo = "gerbil-leveldb";
    rev = "c62e47f352377b6843fb3e4b27030762a510a0d8";
    sha256 = "177zn1smv2zq97mlryf8fi7v5gbjk07v5i0dix3r2wsanphaawvl";
  };

  meta = with lib; {
    description = "LevelDB bindings for Gerbil";
    homepage    = "https://github.com/mighty-gerbils/gerbil-leveldb";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ fare ];
  };

  # "-L${leveldb}/lib"
}
