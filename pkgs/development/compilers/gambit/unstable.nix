{ callPackage, fetchgit }:

callPackage ./build.nix {
  version = "unstable-2018-03-26";
  git-version = "4.8.9-8-g793679bd";
  SRC = fetchgit {
    url = "https://github.com/feeley/gambit.git";
    rev = "793679bd57eb6275cb06e6570b05f4a78df61bf9";
    sha256 = "0bippvmrc8vcaa6ka3mhzfgkagb6a1616g7nxk0i0wapxai5cngj";
  };
}
