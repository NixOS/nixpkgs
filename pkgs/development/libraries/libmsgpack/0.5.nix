{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "0.5.9";

  src = fetchFromGitHub {
    owner = "msgpack";
    repo = "msgpack-c";
    rev = "cpp-${version}";
    sha256 = "19cmlxfr0sc2b08a1mq9plk9fj5l1i20f69j4pvbhlnah3xqfdjs";
  };

  patches = [ ./0.5-CMake.patch ];
})
