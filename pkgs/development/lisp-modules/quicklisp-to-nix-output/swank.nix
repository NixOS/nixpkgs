args @ { fetchurl, ... }:
rec {
  baseName = ''swank'';
  version = ''slime-v2.20'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/slime/2017-08-30/slime-v2.20.tgz'';
    sha256 = ''0rl2ymqxcfkbvwkd8zfhyaaz8v2a927gmv9c43ganxnq6y473c26'';
  };

  packageName = "swank";

  asdFilesToKeep = ["swank.asd"];
  overrides = x: x;
}
/* (SYSTEM swank DESCRIPTION NIL SHA256
    0rl2ymqxcfkbvwkd8zfhyaaz8v2a927gmv9c43ganxnq6y473c26 URL
    http://beta.quicklisp.org/archive/slime/2017-08-30/slime-v2.20.tgz MD5
    115188047b753ce1864586e114ecb46c NAME swank FILENAME swank DEPS NIL
    DEPENDENCIES NIL VERSION slime-v2.20 SIBLINGS NIL PARASITES NIL) */
