{ fetchurl, ... }:
rec {
  baseName = ''trivial-mimes'';
  version = ''20180131-git'';

  description = ''Tiny library to detect mime types in files.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-mimes/2018-01-31/trivial-mimes-20180131-git.tgz'';
    sha256 = ''0wmnfiphrzr5br4mzds7lny36rqrdxv707r4frzygx7j0llrvs1b'';
  };

  packageName = "trivial-mimes";

  asdFilesToKeep = ["trivial-mimes.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-mimes DESCRIPTION
    Tiny library to detect mime types in files. SHA256
    0wmnfiphrzr5br4mzds7lny36rqrdxv707r4frzygx7j0llrvs1b URL
    http://beta.quicklisp.org/archive/trivial-mimes/2018-01-31/trivial-mimes-20180131-git.tgz
    MD5 9c91e72a8ee2455f9c5cbba1f7d2fcef NAME trivial-mimes FILENAME
    trivial-mimes DEPS NIL DEPENDENCIES NIL VERSION 20180131-git SIBLINGS NIL
    PARASITES NIL) */
