/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivial-features";
  version = "20211209-git";

  description = "Ensures consistent *FEATURES* across multiple CLs.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivial-features/2021-12-09/trivial-features-20211209-git.tgz";
    sha256 = "1sxblr86hvbb99isr86y08snfpcajd6ra3396ibqkfnw33hhkgql";
  };

  packageName = "trivial-features";

  asdFilesToKeep = ["trivial-features.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-features DESCRIPTION
    Ensures consistent *FEATURES* across multiple CLs. SHA256
    1sxblr86hvbb99isr86y08snfpcajd6ra3396ibqkfnw33hhkgql URL
    http://beta.quicklisp.org/archive/trivial-features/2021-12-09/trivial-features-20211209-git.tgz
    MD5 eca3e353c7d7f100a07a5aeb4de02098 NAME trivial-features FILENAME
    trivial-features DEPS NIL DEPENDENCIES NIL VERSION 20211209-git SIBLINGS
    (trivial-features-tests) PARASITES NIL) */
