/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "rove";
  version = "20220220-git";

  description = "Yet another testing framework intended to be a successor of Prove";

  deps = [ args."alexandria" args."bordeaux-threads" args."dissect" args."trivial-gray-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/rove/2022-02-20/rove-20220220-git.tgz";
    sha256 = "1r19alfxf82rdswmg5y0lsc9a5qf3jpiqxdv3ip50z6dx7qm794b";
  };

  packageName = "rove";

  asdFilesToKeep = ["rove.asd"];
  overrides = x: x;
}
/* (SYSTEM rove DESCRIPTION
    Yet another testing framework intended to be a successor of Prove SHA256
    1r19alfxf82rdswmg5y0lsc9a5qf3jpiqxdv3ip50z6dx7qm794b URL
    http://beta.quicklisp.org/archive/rove/2022-02-20/rove-20220220-git.tgz MD5
    579688f8d99e742a36b5356ed6776c8f NAME rove FILENAME rove DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME dissect FILENAME dissect)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES (alexandria bordeaux-threads dissect trivial-gray-streams)
    VERSION 20220220-git SIBLINGS NIL PARASITES NIL) */
