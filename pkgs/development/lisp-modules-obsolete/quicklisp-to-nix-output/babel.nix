/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "babel";
  version = "20200925-git";

  description = "Babel, a charset conversion library.";

  deps = [ args."alexandria" args."trivial-features" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/babel/2020-09-25/babel-20200925-git.tgz";
    sha256 = "1hpjm2whw7zla9igzj50y3nibii0mfg2a6y6nslaf5vpkni88jfi";
  };

  packageName = "babel";

  asdFilesToKeep = ["babel.asd"];
  overrides = x: x;
}
/* (SYSTEM babel DESCRIPTION Babel, a charset conversion library. SHA256
    1hpjm2whw7zla9igzj50y3nibii0mfg2a6y6nslaf5vpkni88jfi URL
    http://beta.quicklisp.org/archive/babel/2020-09-25/babel-20200925-git.tgz
    MD5 7f64d3be80bcba19d9caeaede5dea6d8 NAME babel FILENAME babel DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES (alexandria trivial-features) VERSION 20200925-git SIBLINGS
    (babel-streams babel-tests) PARASITES NIL) */
