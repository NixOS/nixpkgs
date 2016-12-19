{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "msgpack";
    repo = "msgpack-c";
    rev = "cpp-${version}";
    sha256 = "189m44pwpcpf7g4yhzfla4djqyp2kl54wxmwfaj94gwgj5s370i7";
  };
})
