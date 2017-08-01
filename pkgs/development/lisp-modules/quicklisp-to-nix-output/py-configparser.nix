args @ { fetchurl, ... }:
rec {
  baseName = ''py-configparser'';
  version = ''20170725-svn'';

  description = ''Common Lisp implementation of the Python ConfigParser module'';

  deps = [ args."parse-number" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/py-configparser/2017-07-25/py-configparser-20170725-svn.tgz'';
    sha256 = ''08wfjlyhjqn54p3k0kv7ijsf72rsn4abdjnhd2bfkapr2a4jz6zr'';
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
/* (SYSTEM py-configparser DESCRIPTION Common Lisp implementation of the Python ConfigParser module SHA256 08wfjlyhjqn54p3k0kv7ijsf72rsn4abdjnhd2bfkapr2a4jz6zr
    URL http://beta.quicklisp.org/archive/py-configparser/2017-07-25/py-configparser-20170725-svn.tgz MD5 3486092bb1d56be05dab16036f288a74 NAME py-configparser
    TESTNAME NIL FILENAME py-configparser DEPS ((NAME parse-number FILENAME parse-number)) DEPENDENCIES (parse-number) VERSION 20170725-svn SIBLINGS NIL) */
