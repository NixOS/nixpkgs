args @ { fetchurl, ... }:
rec {
  baseName = ''closer-mop'';
  version = ''20170227-git'';

  description = ''Closer to MOP is a compatibility layer that rectifies many of the absent or incorrect CLOS MOP features across a broad range of Common Lisp implementations.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/closer-mop/2017-02-27/closer-mop-20170227-git.tgz'';
    sha256 = ''1hdnbryh6gd8kn20yr5ldgkcs8i71c6awwf6a32nmp9l42gwv9k3'';
  };

  overrides = x: {
  };
}
