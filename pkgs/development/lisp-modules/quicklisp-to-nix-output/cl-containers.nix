args @ { fetchurl, ... }:
{
  baseName = ''cl-containers'';
  version = ''20170403-git'';

  parasites = [ "cl-containers/with-moptilities" "cl-containers/with-utilities" ];

  description = ''A generic container library for Common Lisp'';

  deps = [ args."asdf-system-connections" args."metatilities-base" args."moptilities" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-containers/2017-04-03/cl-containers-20170403-git.tgz'';
    sha256 = ''0wlwbz5xv3468iszvmfxnj924mdwx0lyzmhsggiq7iq7ip8wbbxg'';
  };

  packageName = "cl-containers";

  asdFilesToKeep = ["cl-containers.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-containers DESCRIPTION
    A generic container library for Common Lisp SHA256
    0wlwbz5xv3468iszvmfxnj924mdwx0lyzmhsggiq7iq7ip8wbbxg URL
    http://beta.quicklisp.org/archive/cl-containers/2017-04-03/cl-containers-20170403-git.tgz
    MD5 17123cd2b018cd3eb048eceef78be3f8 NAME cl-containers FILENAME
    cl-containers DEPS
    ((NAME asdf-system-connections FILENAME asdf-system-connections)
     (NAME metatilities-base FILENAME metatilities-base)
     (NAME moptilities FILENAME moptilities))
    DEPENDENCIES (asdf-system-connections metatilities-base moptilities)
    VERSION 20170403-git SIBLINGS (cl-containers-test) PARASITES
    (cl-containers/with-moptilities cl-containers/with-utilities)) */
