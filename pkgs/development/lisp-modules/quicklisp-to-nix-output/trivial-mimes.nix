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
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/trivial-mimes[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM trivial-mimes DESCRIPTION Tiny library to detect mime types in files. SHA256 1sdsplngi3civv9wjd9rxxj3ynqc3260cfykpid5lpy8rhbyiw0w URL
    http://beta.quicklisp.org/archive/trivial-mimes/2016-09-29/trivial-mimes-20160929-git.tgz MD5 1075218aae1940bb3413b0edb6b73ac2 NAME trivial-mimes TESTNAME
    NIL FILENAME trivial-mimes DEPS NIL DEPENDENCIES NIL VERSION 20160929-git SIBLINGS NIL) */
