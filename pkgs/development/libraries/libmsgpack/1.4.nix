{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "msgpack";
    repo = "msgpack-c";
    rev = "cpp-${version}";
    sha256 = "0zlanifi5hmm303pzykpidq5jbapl891zwkwhkllfn8ab1jvzbaa";
  };
})
