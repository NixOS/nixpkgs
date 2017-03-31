args @ { fetchurl, ... }:
rec {
  baseName = ''plump-lexer'';
  version = ''plump-20170124-git'';

  description = ''A very simple toolkit to help with lexing used mainly in Plump.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/plump/2017-01-24/plump-20170124-git.tgz'';
    sha256 = ''1swl5kr6hgl7hkybixsx7h4ddc7c0a7pisgmmiz2bs2rv4inz69x'';
  };

  overrides = x: {
  };
}
