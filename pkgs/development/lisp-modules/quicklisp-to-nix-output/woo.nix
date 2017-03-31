args @ { fetchurl, ... }:
rec {
  baseName = ''woo'';
  version = ''20170227-git'';

  description = ''An asynchronous HTTP server written in Common Lisp'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/woo/2017-02-27/woo-20170227-git.tgz'';
    sha256 = ''0myydz817mpkgs97p9y9n4z0kq00xxr2b65klsdkxasvvfyjw0d1'';
  };

  overrides = x: {
  };
}
