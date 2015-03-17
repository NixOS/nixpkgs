{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "msgpack";
    repo = "msgpack-c";
    rev = "cpp-${version}";
    sha256 = "0vkhjil4rh5z9kvjfgzm79kfqwvlimvv49q74wlsjx7vgvv9019d";
  };
})
