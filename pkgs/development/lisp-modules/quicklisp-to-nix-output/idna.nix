args @ { fetchurl, ... }:
rec {
  baseName = ''idna'';
  version = ''20120107-git'';

  description = ''IDNA (international domain names) string encoding and decoding routines'';

  deps = [ args."split-sequence" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/idna/2012-01-07/idna-20120107-git.tgz'';
    sha256 = ''0q9hja9v5q7z89p0bzm2whchn05hymn3255fr5zj3fkja8akma5c'';
  };

  overrides = x: {
  };
}
