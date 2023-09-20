/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-utilities";
  version = "1.2.4";

  description = "System lacks description";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-utilities/2010-10-06/cl-utilities-1.2.4.tgz";
    sha256 = "1z2ippnv2wgyxpz15zpif7j7sp1r20fkjhm4n6am2fyp6a3k3a87";
  };

  packageName = "cl-utilities";

  asdFilesToKeep = ["cl-utilities.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-utilities DESCRIPTION System lacks description SHA256
    1z2ippnv2wgyxpz15zpif7j7sp1r20fkjhm4n6am2fyp6a3k3a87 URL
    http://beta.quicklisp.org/archive/cl-utilities/2010-10-06/cl-utilities-1.2.4.tgz
    MD5 c3a4ba38b627448d3ed40ce888048940 NAME cl-utilities FILENAME
    cl-utilities DEPS NIL DEPENDENCIES NIL VERSION 1.2.4 SIBLINGS NIL PARASITES
    NIL) */
