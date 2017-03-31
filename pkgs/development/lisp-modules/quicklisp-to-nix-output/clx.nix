args @ { fetchurl, ... }:
rec {
  baseName = ''clx'';
  version = ''20170227-git'';

  description = ''An implementation of the X Window System protocol in Lisp.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clx/2017-02-27/clx-20170227-git.tgz'';
    sha256 = ''0zgp1yqy0lm528bhil93ap7df01qdyfhnbxhckjv87xk8rs0g5nx'';
  };

  overrides = x: {
  };
}
