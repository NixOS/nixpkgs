args @ { fetchurl, ... }:
rec {
  baseName = ''cl-colors'';
  version = ''20151218-git'';

  parasites = [ "cl-colors-tests" ];

  description = ''Simple color library for Common Lisp'';

  deps = [ args."alexandria" args."anaphora" args."let-plus" args."lift" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-colors/2015-12-18/cl-colors-20151218-git.tgz'';
    sha256 = ''032kswn6h2ib7v8v1dg0lmgfks7zk52wrv31q6p2zj2a156ccqp4'';
  };

  packageName = "cl-colors";

  asdFilesToKeep = ["cl-colors.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-colors DESCRIPTION Simple color library for Common Lisp SHA256
    032kswn6h2ib7v8v1dg0lmgfks7zk52wrv31q6p2zj2a156ccqp4 URL
    http://beta.quicklisp.org/archive/cl-colors/2015-12-18/cl-colors-20151218-git.tgz
    MD5 2963c3e7aca2c5db2132394f83716515 NAME cl-colors FILENAME cl-colors DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME let-plus FILENAME let-plus) (NAME lift FILENAME lift))
    DEPENDENCIES (alexandria anaphora let-plus lift) VERSION 20151218-git
    SIBLINGS NIL PARASITES (cl-colors-tests)) */
