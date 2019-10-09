args @ { fetchurl, ... }:
rec {
  baseName = ''unix-opts'';
  version = ''20180430-git'';

  description = ''minimalistic parser of command line arguments'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/unix-opts/2018-04-30/unix-opts-20180430-git.tgz'';
    sha256 = ''05glzp47kn022jkbbvhnygaibrqnpr44q19lwhm20h4nkpkj3968'';
  };

  packageName = "unix-opts";

  asdFilesToKeep = ["unix-opts.asd"];
  overrides = x: x;
}
/* (SYSTEM unix-opts DESCRIPTION minimalistic parser of command line arguments
    SHA256 05glzp47kn022jkbbvhnygaibrqnpr44q19lwhm20h4nkpkj3968 URL
    http://beta.quicklisp.org/archive/unix-opts/2018-04-30/unix-opts-20180430-git.tgz
    MD5 2875ea0a1f5c49ef2697bb1046c4c4e5 NAME unix-opts FILENAME unix-opts DEPS
    NIL DEPENDENCIES NIL VERSION 20180430-git SIBLINGS (unix-opts-tests)
    PARASITES NIL) */
