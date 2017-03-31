args @ { fetchurl, ... }:
rec {
  baseName = ''form-fiddle'';
  version = ''20160929-git'';

  description = ''A collection of utilities to destructure lambda forms.'';

  deps = [ args."documentation-utils" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/form-fiddle/2016-09-29/form-fiddle-20160929-git.tgz'';
    sha256 = ''1lmdxvwh0d81jlkc9qq2cw0bizjbmk7f5fjcb8ps65andfyj9bd7'';
  };

  overrides = x: {
  };
}
