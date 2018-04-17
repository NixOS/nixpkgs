{ callPackage, fetchgit }:

callPackage ./build.nix {
  version = "4.8.9";
  # TODO: for next version, prefer the unpatched tarball for the stable/default gambit.
  git-version = "4.8.9-8-g793679bd";

  SRC = fetchgit {
    url = "https://github.com/feeley/gambit.git";
    rev = "dd54a71dfc0bd09813592f1645d755867a02195d";
    sha256 = "120kg73k39gshrwas8a3xcrxgnq1c7ww92wgy4d3mmrwy3j9nzzc";
  };
}
