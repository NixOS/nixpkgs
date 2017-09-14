args @ { fetchurl, ... }:
rec {
  baseName = ''wookie'';
  version = ''20170227-git'';

  description = ''An evented webserver for Common Lisp.'';

  deps = [ args."alexandria" args."babel" args."blackbird" args."chunga" args."cl-async" args."cl-async-ssl" args."cl-fad" args."cl-ppcre" args."do-urlencode" args."fast-http" args."fast-io" args."quri" args."vom" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/wookie/2017-02-27/wookie-20170227-git.tgz'';
    sha256 = ''0i1wrgr5grg387ldv1zfswws1g3xvrkxxvp1m58m9hj0c1vmm6v0'';
  };

  packageName = "wookie";

  asdFilesToKeep = ["wookie.asd"];
  overrides = x: x;
}
/* (SYSTEM wookie DESCRIPTION An evented webserver for Common Lisp. SHA256
    0i1wrgr5grg387ldv1zfswws1g3xvrkxxvp1m58m9hj0c1vmm6v0 URL
    http://beta.quicklisp.org/archive/wookie/2017-02-27/wookie-20170227-git.tgz
    MD5 aeb084106facdc9c8dab100c97e05b92 NAME wookie FILENAME wookie DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME blackbird FILENAME blackbird) (NAME chunga FILENAME chunga)
     (NAME cl-async FILENAME cl-async)
     (NAME cl-async-ssl FILENAME cl-async-ssl) (NAME cl-fad FILENAME cl-fad)
     (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME do-urlencode FILENAME do-urlencode)
     (NAME fast-http FILENAME fast-http) (NAME fast-io FILENAME fast-io)
     (NAME quri FILENAME quri) (NAME vom FILENAME vom))
    DEPENDENCIES
    (alexandria babel blackbird chunga cl-async cl-async-ssl cl-fad cl-ppcre
     do-urlencode fast-http fast-io quri vom)
    VERSION 20170227-git SIBLINGS NIL PARASITES NIL) */
