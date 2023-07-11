/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-geometry";
  version = "20160531-git";

  description = "Library for two dimensional geometry.";

  deps = [ args."iterate" args."trees" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-geometry/2016-05-31/cl-geometry-20160531-git.tgz";
    sha256 = "0v451w2dx9llvd2kgp3m5jn2n8n0xwynxf8zl436cngh63ag6s7p";
  };

  packageName = "cl-geometry";

  asdFilesToKeep = ["cl-geometry.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-geometry DESCRIPTION Library for two dimensional geometry. SHA256
    0v451w2dx9llvd2kgp3m5jn2n8n0xwynxf8zl436cngh63ag6s7p URL
    http://beta.quicklisp.org/archive/cl-geometry/2016-05-31/cl-geometry-20160531-git.tgz
    MD5 c0aaccbb4e2df6c504e6c1cd15155353 NAME cl-geometry FILENAME cl-geometry
    DEPS ((NAME iterate FILENAME iterate) (NAME trees FILENAME trees))
    DEPENDENCIES (iterate trees) VERSION 20160531-git SIBLINGS
    (cl-geometry-tests) PARASITES NIL) */
