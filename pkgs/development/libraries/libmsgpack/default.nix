{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2.1.5";

  src = fetchFromGitHub {
    owner  = "msgpack";
    repo   = "msgpack-c";
    rev    = "cpp-${version}";
    sha256 = "0n4kvma3dldfsvv7b0zw23qln6av5im2aqqd6m890i75zwwkw0zv";
  };
})
