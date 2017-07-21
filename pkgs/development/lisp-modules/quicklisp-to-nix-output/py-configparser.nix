args @ { fetchurl, ... }:
rec {
  baseName = ''py-configparser'';
  version = ''20131003-svn'';

  description = ''Common Lisp implementation of the Python ConfigParser module'';

  deps = [ args."parse-number" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/py-configparser/2013-10-03/py-configparser-20131003-svn.tgz'';
    sha256 = ''10csqvl2acsha70igy75np2lf3bx7rrlrgryslsqay2xdzk6alwx'';
  };
    
  packageName = "py-configparser";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/py-configparser[.]asd${"$"}' |
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
/* (SYSTEM py-configparser DESCRIPTION Common Lisp implementation of the Python ConfigParser module SHA256 10csqvl2acsha70igy75np2lf3bx7rrlrgryslsqay2xdzk6alwx
    URL http://beta.quicklisp.org/archive/py-configparser/2013-10-03/py-configparser-20131003-svn.tgz MD5 da697259b68f536bcb6b77933b55a5d9 NAME py-configparser
    TESTNAME NIL FILENAME py-configparser DEPS ((NAME parse-number FILENAME parse-number)) DEPENDENCIES (parse-number) VERSION 20131003-svn SIBLINGS NIL) */
