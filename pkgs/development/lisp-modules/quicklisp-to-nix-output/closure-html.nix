args @ { fetchurl, ... }:
rec {
  baseName = ''closure-html'';
  version = ''20140826-git'';

  description = '''';

  deps = [ args."alexandria" args."babel" args."closure-common" args."flexi-streams" args."trivial-features" args."trivial-gray-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/closure-html/2014-08-26/closure-html-20140826-git.tgz'';
    sha256 = ''1m07iv9r5ykj52fszwhwai5wv39mczk3m4zzh24gjhsprv35x8qb'';
  };

  packageName = "closure-html";

  asdFilesToKeep = ["closure-html.asd"];
  overrides = x: x;
}
/* (SYSTEM closure-html DESCRIPTION NIL SHA256
    1m07iv9r5ykj52fszwhwai5wv39mczk3m4zzh24gjhsprv35x8qb URL
    http://beta.quicklisp.org/archive/closure-html/2014-08-26/closure-html-20140826-git.tgz
    MD5 3f8d8a4fd54f915ca6cc5fdf29239d98 NAME closure-html FILENAME
    closure-html DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME closure-common FILENAME closure-common)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES
    (alexandria babel closure-common flexi-streams trivial-features
     trivial-gray-streams)
    VERSION 20140826-git SIBLINGS NIL PARASITES NIL) */
