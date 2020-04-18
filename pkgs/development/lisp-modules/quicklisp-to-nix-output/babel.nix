args @ { fetchurl, ... }:
rec {
  baseName = ''babel'';
  version = ''20191130-git'';

  description = ''Babel, a charset conversion library.'';

  deps = [ args."alexandria" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/babel/2019-11-30/babel-20191130-git.tgz'';
    sha256 = ''0rnb7waq3fi51g2fxrazkyr2fmksqp0syjhni005vzzlbykmkavd'';
  };

  packageName = "babel";

  asdFilesToKeep = ["babel.asd"];
  overrides = x: x;
}
/* (SYSTEM babel DESCRIPTION Babel, a charset conversion library. SHA256
    0rnb7waq3fi51g2fxrazkyr2fmksqp0syjhni005vzzlbykmkavd URL
    http://beta.quicklisp.org/archive/babel/2019-11-30/babel-20191130-git.tgz
    MD5 80087c99fe351d24e56bb279a62effeb NAME babel FILENAME babel DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES (alexandria trivial-features) VERSION 20191130-git SIBLINGS
    (babel-streams babel-tests) PARASITES NIL) */
