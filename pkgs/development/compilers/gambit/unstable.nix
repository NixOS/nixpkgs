{ callPackage, fetchFromGitHub, gambit-support }:

callPackage ./build.nix {
  version = "unstable-2020-05-15";
  git-version = "4.9.3-1109-g3c4d40de";
  src = fetchFromGitHub {
    owner = "feeley";
    repo = "gambit";
    rev = "3c4d40de908ae03ca0e3d854edc2234ef401b36c";
    sha256 = "1c9a6rys2kiiqb79gvw29nv3dwwk6hmi1q4jk1whcx7mds7q5dvr";
  };
  gambit-params = gambit-support.unstable-params;
}
