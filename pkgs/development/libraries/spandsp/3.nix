{ fetchFromGitHub
, callPackage
}:

(callPackage ./common.nix {}).overrideAttrs(previousAttrs: {
  version = "3.0.0";
  src = fetchFromGitHub {
    owner = "freeswitch";
    repo = previousAttrs.pname;
    rev = "6ec23e5a7e411a22d59e5678d12c4d2942c4a4b6"; # upstream does not seem to believe in tags
    sha256 = "03w0s99y3zibi5fnvn8lk92dggfgrr0mz5255745jfbz28b2d5y7";
  };
})
