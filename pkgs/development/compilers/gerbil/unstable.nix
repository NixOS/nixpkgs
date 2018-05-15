{ callPackage, fetchgit, gambit-unstable }:

callPackage ./build.nix {
  version = "unstable-2018-04-03";
  git-version = "0.13-DEV-357-ge61318dc";
  GAMBIT = gambit-unstable;
  SRC = fetchgit {
    url = "https://github.com/vyzo/gerbil.git";
    rev = "e61318dcaa3a9c843e2cf259e67851f240e4beda";
    sha256 = "1xd7yxiramifdxgp6b3s24z6nkkmy5h4a6pkchvy4w358qv1vqin";
  };
}
