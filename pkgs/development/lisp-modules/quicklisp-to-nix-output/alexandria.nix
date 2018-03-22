args @ { fetchurl, ... }:
rec {
  baseName = ''alexandria'';
  version = ''20170830-git'';

  description = ''Alexandria is a collection of portable public domain utilities.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/alexandria/2017-08-30/alexandria-20170830-git.tgz'';
    sha256 = ''0vprl8kg5qahwp8zyc26bk0qpdynga9hbv5qnlvk3cclfpvm8kl9'';
  };

  packageName = "alexandria";

  asdFilesToKeep = ["alexandria.asd"];
  overrides = x: x;
}
/* (SYSTEM alexandria DESCRIPTION
    Alexandria is a collection of portable public domain utilities. SHA256
    0vprl8kg5qahwp8zyc26bk0qpdynga9hbv5qnlvk3cclfpvm8kl9 URL
    http://beta.quicklisp.org/archive/alexandria/2017-08-30/alexandria-20170830-git.tgz
    MD5 13ea5af7055094a87dec1e45090f894a NAME alexandria FILENAME alexandria
    DEPS NIL DEPENDENCIES NIL VERSION 20170830-git SIBLINGS (alexandria-tests)
    PARASITES NIL) */
