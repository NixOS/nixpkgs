/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "rove";
  version = "20211020-git";

  description = "Yet another testing framework intended to be a successor of Prove";

  deps = [ args."alexandria" args."bordeaux-threads" args."dissect" args."trivial-gray-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/rove/2021-10-20/rove-20211020-git.tgz";
    sha256 = "1p54dp4m2wnmff6dyfh2k4crk83n38nyix1g8csixvn8jkk2gi4b";
  };

  packageName = "rove";

  asdFilesToKeep = ["rove.asd"];
  overrides = x: x;
}
/* (SYSTEM rove DESCRIPTION
    Yet another testing framework intended to be a successor of Prove SHA256
    1p54dp4m2wnmff6dyfh2k4crk83n38nyix1g8csixvn8jkk2gi4b URL
    http://beta.quicklisp.org/archive/rove/2021-10-20/rove-20211020-git.tgz MD5
    119a5c0f506db2b301eb19bfed7c403d NAME rove FILENAME rove DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME dissect FILENAME dissect)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES (alexandria bordeaux-threads dissect trivial-gray-streams)
    VERSION 20211020-git SIBLINGS NIL PARASITES NIL) */
