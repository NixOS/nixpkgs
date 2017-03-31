args @ { fetchurl, ... }:
rec {
  baseName = ''cl-unicode'';
  version = ''0.1.5'';

  description = ''Portable Unicode Library'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-unicode/2014-12-17/cl-unicode-0.1.5.tgz'';
    sha256 = ''1jd5qq5ji6l749c4x415z22y9r0k9z18pdi9p9fqvamzh854i46n'';
  };

  overrides = x: {
  };
}
