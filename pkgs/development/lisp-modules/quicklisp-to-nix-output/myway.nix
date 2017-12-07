args @ { fetchurl, ... }:
rec {
  baseName = ''myway'';
  version = ''20150302-git'';

  description = ''Sinatra-compatible routing library.'';

  deps = [ args."alexandria" args."babel" args."cl-ppcre" args."cl-utilities" args."map-set" args."quri" args."split-sequence" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/myway/2015-03-02/myway-20150302-git.tgz'';
    sha256 = ''1spab9zzhwjg3r5xncr5ncha7phw72wp49cxxncgphh1lfaiyblh'';
  };

  packageName = "myway";

  asdFilesToKeep = ["myway.asd"];
  overrides = x: x;
}
/* (SYSTEM myway DESCRIPTION Sinatra-compatible routing library. SHA256
    1spab9zzhwjg3r5xncr5ncha7phw72wp49cxxncgphh1lfaiyblh URL
    http://beta.quicklisp.org/archive/myway/2015-03-02/myway-20150302-git.tgz
    MD5 6a16b41eb3216c469bfc8783cce08b01 NAME myway FILENAME myway DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-utilities FILENAME cl-utilities) (NAME map-set FILENAME map-set)
     (NAME quri FILENAME quri) (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel cl-ppcre cl-utilities map-set quri split-sequence
     trivial-features)
    VERSION 20150302-git SIBLINGS (myway-test) PARASITES NIL) */
