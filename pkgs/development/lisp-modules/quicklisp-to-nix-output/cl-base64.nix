args @ { fetchurl, ... }:
rec {
  baseName = ''cl-base64'';
  version = ''20150923-git'';

  description = ''Base64 encoding and decoding with URI support.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-base64/2015-09-23/cl-base64-20150923-git.tgz'';
    sha256 = ''0haip5x0091r9xa8gdzr21s0rk432998nbxxfys35lhnyc1vgyhp'';
  };

  overrides = x: {
  };
}
