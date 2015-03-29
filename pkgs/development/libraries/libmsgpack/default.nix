{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "msgpack";
    repo = "msgpack-c";
    rev = "cpp-${version}";
    sha256 = "0qyjz2rm0gxbv81dlh28ynss66dsyhlqzs09rblbjsdf1vh6yzcq";
  };
})
