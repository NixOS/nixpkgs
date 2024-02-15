/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "unix-options";
  version = "20151031-git";

  description = "Easy to use command line option parser";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/unix-options/2015-10-31/unix-options-20151031-git.tgz";
    sha256 = "0c9vbvvyx5qwvns87624gzxjcbdkbkcwssg29cxjfv3ci3qwqcd5";
  };

  packageName = "unix-options";

  asdFilesToKeep = ["unix-options.asd"];
  overrides = x: x;
}
/* (SYSTEM unix-options DESCRIPTION Easy to use command line option parser
    SHA256 0c9vbvvyx5qwvns87624gzxjcbdkbkcwssg29cxjfv3ci3qwqcd5 URL
    http://beta.quicklisp.org/archive/unix-options/2015-10-31/unix-options-20151031-git.tgz
    MD5 3bbdeafbef3e7a2e94b9756bf173f636 NAME unix-options FILENAME
    unix-options DEPS NIL DEPENDENCIES NIL VERSION 20151031-git SIBLINGS NIL
    PARASITES NIL) */
