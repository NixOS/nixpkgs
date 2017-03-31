args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-mimes'';
  version = ''20160929-git'';

  description = ''Tiny library to detect mime types in files.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-mimes/2016-09-29/trivial-mimes-20160929-git.tgz'';
    sha256 = ''1sdsplngi3civv9wjd9rxxj3ynqc3260cfykpid5lpy8rhbyiw0w'';
  };

  overrides = x: {
  };
}
