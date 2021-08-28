/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "rove";
  version = "20200325-git";

  description = "Yet another testing framework intended to be a successor of Prove";

  deps = [ args."bordeaux-threads" args."dissect" args."trivial-gray-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/rove/2020-03-25/rove-20200325-git.tgz";
    sha256 = "0zn8d3408rgy2nibia5hdfbf80ix1fgssywx01izx7z99l5x50z5";
  };

  packageName = "rove";

  asdFilesToKeep = ["rove.asd"];
  overrides = x: x;
}
/* (SYSTEM rove DESCRIPTION
    Yet another testing framework intended to be a successor of Prove SHA256
    0zn8d3408rgy2nibia5hdfbf80ix1fgssywx01izx7z99l5x50z5 URL
    http://beta.quicklisp.org/archive/rove/2020-03-25/rove-20200325-git.tgz MD5
    7954cb65830d62142babecebf20d0226 NAME rove FILENAME rove DEPS
    ((NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME dissect FILENAME dissect)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES (bordeaux-threads dissect trivial-gray-streams) VERSION
    20200325-git SIBLINGS NIL PARASITES NIL) */
