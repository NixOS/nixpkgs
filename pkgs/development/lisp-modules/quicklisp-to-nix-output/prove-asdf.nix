args @ { fetchurl, ... }:
rec {
  baseName = ''prove-asdf'';
  version = ''prove-20171130-git'';

  description = ''System lacks description'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/prove/2017-11-30/prove-20171130-git.tgz'';
    sha256 = ''13dmnnlk3r9fxxcvk6sqq8m0ifv9y80zgp1wg63nv1ykwdi7kyar'';
  };

  packageName = "prove-asdf";

  asdFilesToKeep = ["prove-asdf.asd"];
  overrides = x: x;
}
/* (SYSTEM prove-asdf DESCRIPTION System lacks description SHA256
    13dmnnlk3r9fxxcvk6sqq8m0ifv9y80zgp1wg63nv1ykwdi7kyar URL
    http://beta.quicklisp.org/archive/prove/2017-11-30/prove-20171130-git.tgz
    MD5 630df4367537f799570be40242f8ed52 NAME prove-asdf FILENAME prove-asdf
    DEPS NIL DEPENDENCIES NIL VERSION prove-20171130-git SIBLINGS
    (cl-test-more prove-test prove) PARASITES NIL) */
