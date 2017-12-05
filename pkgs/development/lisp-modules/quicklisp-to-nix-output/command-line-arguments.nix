args @ { fetchurl, ... }:
rec {
  baseName = ''command-line-arguments'';
  version = ''20151218-git'';

  description = ''small library to deal with command-line arguments'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/command-line-arguments/2015-12-18/command-line-arguments-20151218-git.tgz'';
    sha256 = ''07yv3vj9kjd84q09d6kvgryqxb71bsa7jl22fd1an6inmk0a3yyh'';
  };
    
  packageName = "command-line-arguments";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/command-line-arguments[.]asd${"$"}' |
        while read f; do
          env -i \
          NIX_LISP="$NIX_LISP" \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(progn
            (asdf:load-system :$(basename "$f" .asd))
            (asdf:perform (quote asdf:compile-bundle-op) :$(basename "$f" .asd))
            (ignore-errors (asdf:perform (quote asdf:deliver-asd-op) :$(basename "$f" .asd)))
            )'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM command-line-arguments DESCRIPTION small library to deal with command-line arguments SHA256 07yv3vj9kjd84q09d6kvgryqxb71bsa7jl22fd1an6inmk0a3yyh URL
    http://beta.quicklisp.org/archive/command-line-arguments/2015-12-18/command-line-arguments-20151218-git.tgz MD5 8cdb99db40143e34cf6b0b25ca95f826 NAME
    command-line-arguments TESTNAME NIL FILENAME command-line-arguments DEPS NIL DEPENDENCIES NIL VERSION 20151218-git SIBLINGS NIL) */
