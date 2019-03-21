args @ { fetchurl, ... }:
rec {
  baseName = ''closure-html'';
  version = ''20180711-git'';

  description = '''';

  deps = [ args."alexandria" args."babel" args."closure-common" args."flexi-streams" args."trivial-features" args."trivial-gray-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/closure-html/2018-07-11/closure-html-20180711-git.tgz'';
    sha256 = ''0ljcrz1wix77h1ywp0bixm3pb5ncmr1vdiwh8m1qzkygwpfjr8aq'';
  };

  packageName = "closure-html";

  asdFilesToKeep = ["closure-html.asd"];
  overrides = x: x;
}
/* (SYSTEM closure-html DESCRIPTION NIL SHA256
    0ljcrz1wix77h1ywp0bixm3pb5ncmr1vdiwh8m1qzkygwpfjr8aq URL
    http://beta.quicklisp.org/archive/closure-html/2018-07-11/closure-html-20180711-git.tgz
    MD5 461dc8caa65385da5f2d1cd8dd4f965f NAME closure-html FILENAME
    closure-html DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME closure-common FILENAME closure-common)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES
    (alexandria babel closure-common flexi-streams trivial-features
     trivial-gray-streams)
    VERSION 20180711-git SIBLINGS NIL PARASITES NIL) */
