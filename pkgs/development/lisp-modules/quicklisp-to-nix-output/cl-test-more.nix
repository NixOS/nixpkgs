args @ { fetchurl, ... }:
{
  baseName = ''cl-test-more'';
  version = ''prove-20171130-git'';

  description = ''System lacks description'';

  deps = [ args."alexandria" args."anaphora" args."cl-ansi-text" args."cl-colors" args."cl-ppcre" args."let-plus" args."prove" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/prove/2017-11-30/prove-20171130-git.tgz'';
    sha256 = ''13dmnnlk3r9fxxcvk6sqq8m0ifv9y80zgp1wg63nv1ykwdi7kyar'';
  };

  packageName = "cl-test-more";

  asdFilesToKeep = ["cl-test-more.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-test-more DESCRIPTION System lacks description SHA256
    13dmnnlk3r9fxxcvk6sqq8m0ifv9y80zgp1wg63nv1ykwdi7kyar URL
    http://beta.quicklisp.org/archive/prove/2017-11-30/prove-20171130-git.tgz
    MD5 630df4367537f799570be40242f8ed52 NAME cl-test-more FILENAME
    cl-test-more DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME cl-ansi-text FILENAME cl-ansi-text)
     (NAME cl-colors FILENAME cl-colors) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME let-plus FILENAME let-plus) (NAME prove FILENAME prove))
    DEPENDENCIES
    (alexandria anaphora cl-ansi-text cl-colors cl-ppcre let-plus prove)
    VERSION prove-20171130-git SIBLINGS (prove-asdf prove-test prove) PARASITES
    NIL) */
