args @ { fetchurl, ... }:
rec {
  baseName = ''external-program'';
  version = ''20160825-git'';

  description = '''';

  deps = [ args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/external-program/2016-08-25/external-program-20160825-git.tgz'';
    sha256 = ''0avnnhxxa1wfri9i3m1339nszyp1w2cilycc948nf5awz4mckq13'';
  };

  overrides = x: {
  };
}
