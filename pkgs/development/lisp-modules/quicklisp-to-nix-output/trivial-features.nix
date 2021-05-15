/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivial-features";
  version = "20210411-git";

  description = "Ensures consistent *FEATURES* across multiple CLs.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivial-features/2021-04-11/trivial-features-20210411-git.tgz";
    sha256 = "0z6nzql8z7bz8kzd08mh36h0r54vqx7pwigy8r617jhvb0r0n0n4";
  };

  packageName = "trivial-features";

  asdFilesToKeep = ["trivial-features.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-features DESCRIPTION
    Ensures consistent *FEATURES* across multiple CLs. SHA256
    0z6nzql8z7bz8kzd08mh36h0r54vqx7pwigy8r617jhvb0r0n0n4 URL
    http://beta.quicklisp.org/archive/trivial-features/2021-04-11/trivial-features-20210411-git.tgz
    MD5 5ec554fff48d38af5023604a1ae42d3a NAME trivial-features FILENAME
    trivial-features DEPS NIL DEPENDENCIES NIL VERSION 20210411-git SIBLINGS
    (trivial-features-tests) PARASITES NIL) */
