{
  pkgs,
  lib,
  fetchFromGitHub,
  lmdb,
  ...
}:

{
  pname = "gerbil-lmdb";
  version = "unstable-2023-09-23";
  git-version = "6d64813";
  gerbil-package = "clan";
  gerbilInputs = [ ];
  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [ lmdb ];
  version-path = "";
  softwareName = "Gerbil-LMDB";

  pre-src = {
    fun = fetchFromGitHub;
    owner = "mighty-gerbils";
    repo = "gerbil-lmdb";
    rev = "6d64813afe5766776a0d7ef45f80c784b820742c";
    sha256 = "12kywxx4qjxchmhcd66700r2yfqjnh12ijgqnpqaccvigi07iq9b";
  };

<<<<<<< HEAD
  meta = {
    description = "LMDB bindings for Gerbil";
    homepage = "https://github.com/mighty-gerbils/gerbil-lmdb";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ fare ];
=======
  meta = with lib; {
    description = "LMDB bindings for Gerbil";
    homepage = "https://github.com/mighty-gerbils/gerbil-lmdb";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fare ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  # "-L${lmdb.out}/lib"
}
