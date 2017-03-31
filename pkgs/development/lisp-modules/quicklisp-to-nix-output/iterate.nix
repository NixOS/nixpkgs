args @ { fetchurl, ... }:
rec {
  baseName = ''iterate'';
  version = ''20160825-darcs'';

  description = ''Jonathan Amsterdam's iterator/gatherer/accumulator facility'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/iterate/2016-08-25/iterate-20160825-darcs.tgz'';
    sha256 = ''0kvz16gnxnkdz0fy1x8y5yr28nfm7i2qpvix7mgwccdpjmsb4pgm'';
  };

  overrides = x: {
  };
}
