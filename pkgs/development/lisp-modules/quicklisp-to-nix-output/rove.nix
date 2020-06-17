args @ { fetchurl, ... }:
rec {
  baseName = ''rove'';
  version = ''20191007-git'';

  description = ''Yet another testing framework intended to be a successor of Prove'';

  deps = [ args."bordeaux-threads" args."dissect" args."trivial-gray-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/rove/2019-10-07/rove-20191007-git.tgz'';
    sha256 = ''0ngklk69rn13qgsy9h07sqfqzyl1wqsfrp7izx6whgs62bm0vixa'';
  };

  packageName = "rove";

  asdFilesToKeep = ["rove.asd"];
  overrides = x: x;
}
/* (SYSTEM rove DESCRIPTION
    Yet another testing framework intended to be a successor of Prove SHA256
    0ngklk69rn13qgsy9h07sqfqzyl1wqsfrp7izx6whgs62bm0vixa URL
    http://beta.quicklisp.org/archive/rove/2019-10-07/rove-20191007-git.tgz MD5
    7ce5d3b0b423f8b68665bbcc51cf18a1 NAME rove FILENAME rove DEPS
    ((NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME dissect FILENAME dissect)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES (bordeaux-threads dissect trivial-gray-streams) VERSION
    20191007-git SIBLINGS NIL PARASITES NIL) */
