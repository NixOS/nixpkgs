/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "rove";
  version = "20211209-git";

  description = "Yet another testing framework intended to be a successor of Prove";

  deps = [ args."alexandria" args."bordeaux-threads" args."dissect" args."trivial-gray-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/rove/2021-12-09/rove-20211209-git.tgz";
    sha256 = "1b1fajdxnba743l7mv4nc31az2g7mapalq3z3l57j7r5sximf0qr";
  };

  packageName = "rove";

  asdFilesToKeep = ["rove.asd"];
  overrides = x: x;
}
/* (SYSTEM rove DESCRIPTION
    Yet another testing framework intended to be a successor of Prove SHA256
    1b1fajdxnba743l7mv4nc31az2g7mapalq3z3l57j7r5sximf0qr URL
    http://beta.quicklisp.org/archive/rove/2021-12-09/rove-20211209-git.tgz MD5
    d9f6cb2e26f06cfbd5c83bf3fa4fc206 NAME rove FILENAME rove DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME dissect FILENAME dissect)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES (alexandria bordeaux-threads dissect trivial-gray-streams)
    VERSION 20211209-git SIBLINGS NIL PARASITES NIL) */
