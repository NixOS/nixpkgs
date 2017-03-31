args @ { fetchurl, ... }:
rec {
  baseName = ''cl-store'';
  version = ''20160531-git'';

  description = ''Serialization package'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-store/2016-05-31/cl-store-20160531-git.tgz'';
    sha256 = ''0j1pfgvzy6l7hb68xsz2dghsa94lip7caq6f6608jsqadmdswljz'';
  };

  overrides = x: {
  };
}
