/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-containers";
  version = "20200427-git";

  parasites = [ "cl-containers/with-moptilities" "cl-containers/with-utilities" ];

  description = "A generic container library for Common Lisp";

  deps = [ args."asdf-system-connections" args."metatilities-base" args."moptilities" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-containers/2020-04-27/cl-containers-20200427-git.tgz";
    sha256 = "0llaymnlss0dhwyqgr2s38w1hjb2as1x1nn57qcvdphnm7qs50fy";
  };

  packageName = "cl-containers";

  asdFilesToKeep = ["cl-containers.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-containers DESCRIPTION
    A generic container library for Common Lisp SHA256
    0llaymnlss0dhwyqgr2s38w1hjb2as1x1nn57qcvdphnm7qs50fy URL
    http://beta.quicklisp.org/archive/cl-containers/2020-04-27/cl-containers-20200427-git.tgz
    MD5 bb0e03a581e9b617dd166a3f511eaf6a NAME cl-containers FILENAME
    cl-containers DEPS
    ((NAME asdf-system-connections FILENAME asdf-system-connections)
     (NAME metatilities-base FILENAME metatilities-base)
     (NAME moptilities FILENAME moptilities))
    DEPENDENCIES (asdf-system-connections metatilities-base moptilities)
    VERSION 20200427-git SIBLINGS (cl-containers-test) PARASITES
    (cl-containers/with-moptilities cl-containers/with-utilities)) */
