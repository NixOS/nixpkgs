args @ { fetchurl, ... }:
rec {
  baseName = ''uiop'';
  version = ''3.3.3'';

  description = ''System lacks description'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/uiop/2019-05-21/uiop-3.3.3.tgz'';
    sha256 = ''1r89bqjmz1919l3wlmd32p416jzpacy3glkhiwnf1crkja27iagm'';
  };

  packageName = "uiop";

  asdFilesToKeep = ["uiop.asd"];
  overrides = x: x;
}
/* (SYSTEM uiop DESCRIPTION System lacks description SHA256
    1r89bqjmz1919l3wlmd32p416jzpacy3glkhiwnf1crkja27iagm URL
    http://beta.quicklisp.org/archive/uiop/2019-05-21/uiop-3.3.3.tgz MD5
    64d561117f048ad8621eff7a6173d65e NAME uiop FILENAME uiop DEPS NIL
    DEPENDENCIES NIL VERSION 3.3.3 SIBLINGS (asdf-driver) PARASITES NIL) */
