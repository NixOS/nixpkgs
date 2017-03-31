args @ { fetchurl, ... }:
rec {
  baseName = ''plump-dom'';
  version = ''plump-20170124-git'';

  description = ''A DOM for use with the Plump parser.'';

  deps = [ args."array-utils" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/plump/2017-01-24/plump-20170124-git.tgz'';
    sha256 = ''1swl5kr6hgl7hkybixsx7h4ddc7c0a7pisgmmiz2bs2rv4inz69x'';
  };

  overrides = x: {
  };
}
