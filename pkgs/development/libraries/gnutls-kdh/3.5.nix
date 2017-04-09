{ callPackage, fetchFromGitHub, autoreconfHook, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.0";

  src = fetchFromGitHub {
    owner = "arpa2";
    repo = "gnutls-kdh";
    rev = "ff3bb36f70a746f28554641d466e124098dfcb25";
    sha256 = "1rr3p4r145lnprxn8hqyyzh3qkj3idsbqp08g07ndrhqnxq0k0sw";
  };
})
