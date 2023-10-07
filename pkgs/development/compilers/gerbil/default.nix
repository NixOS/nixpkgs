{ callPackage, fetchFromGitHub }:

callPackage ./build.nix rec {
  version = "0.17";
  git-version = version;
  src = fetchFromGitHub {
    owner = "vyzo";
    repo = "gerbil";
    rev = "v${version}";
    sha256 = "0xzi9mhrmzcajhlz5qcnz4yjlljvbkbm9426iifgjn47ac0965zw";
  };
}
