args @ { fetchurl, ... }:
rec {
  baseName = ''md5'';
  version = ''20170516-git'';

  description = ''The MD5 Message-Digest Algorithm RFC 1321'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/md5/2017-05-16/md5-20170516-git.tgz'';
    sha256 = ''1jmhww8wvd66ky5vppr0g8hi52w6z3q7svsqcmdrgzifr01r0pcv'';
  };
    
  packageName = "md5";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/md5[.]asd${"$"}' |
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
/* (SYSTEM md5 DESCRIPTION The MD5 Message-Digest Algorithm RFC 1321 SHA256 1jmhww8wvd66ky5vppr0g8hi52w6z3q7svsqcmdrgzifr01r0pcv URL
    http://beta.quicklisp.org/archive/md5/2017-05-16/md5-20170516-git.tgz MD5 1c90df8ab2c6d57b7abaac84cae30ab3 NAME md5 TESTNAME NIL FILENAME md5 DEPS NIL
    DEPENDENCIES NIL VERSION 20170516-git SIBLINGS NIL) */
