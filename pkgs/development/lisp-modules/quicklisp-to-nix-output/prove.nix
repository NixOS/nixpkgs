args @ { fetchurl, ... }:
{
  baseName = ''prove'';
  version = ''20171130-git'';

  description = '''';

  deps = [ args."alexandria" args."anaphora" args."cl-ansi-text" args."cl-colors" args."cl-ppcre" args."let-plus" args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/prove/2017-11-30/prove-20171130-git.tgz'';
    sha256 = ''13dmnnlk3r9fxxcvk6sqq8m0ifv9y80zgp1wg63nv1ykwdi7kyar'';
  };

  packageName = "prove";

  asdFilesToKeep = ["prove.asd"];
  overrides = x: x;
}
/* (SYSTEM prove DESCRIPTION NIL SHA256
    13dmnnlk3r9fxxcvk6sqq8m0ifv9y80zgp1wg63nv1ykwdi7kyar URL
    http://beta.quicklisp.org/archive/prove/2017-11-30/prove-20171130-git.tgz
    MD5 630df4367537f799570be40242f8ed52 NAME prove FILENAME prove DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME cl-ansi-text FILENAME cl-ansi-text)
     (NAME cl-colors FILENAME cl-colors) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME let-plus FILENAME let-plus) (NAME uiop FILENAME uiop))
    DEPENDENCIES
    (alexandria anaphora cl-ansi-text cl-colors cl-ppcre let-plus uiop) VERSION
    20171130-git SIBLINGS (cl-test-more prove-asdf prove-test) PARASITES NIL) */
