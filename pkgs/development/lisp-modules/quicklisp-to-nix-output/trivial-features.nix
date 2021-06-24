/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivial-features";
  version = "20210228-git";

  description = "Ensures consistent *FEATURES* across multiple CLs.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivial-features/2021-02-28/trivial-features-20210228-git.tgz";
    sha256 = "1najk88r8nlpbxm8mjfj8b22f9chr9h2hxg9wqz87kkmhg4rfwwj";
  };

  packageName = "trivial-features";

  asdFilesToKeep = ["trivial-features.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-features DESCRIPTION
    Ensures consistent *FEATURES* across multiple CLs. SHA256
    1najk88r8nlpbxm8mjfj8b22f9chr9h2hxg9wqz87kkmhg4rfwwj URL
    http://beta.quicklisp.org/archive/trivial-features/2021-02-28/trivial-features-20210228-git.tgz
    MD5 6d628c0c941346773751a684213a52d7 NAME trivial-features FILENAME
    trivial-features DEPS NIL DEPENDENCIES NIL VERSION 20210228-git SIBLINGS
    (trivial-features-tests) PARASITES NIL) */
