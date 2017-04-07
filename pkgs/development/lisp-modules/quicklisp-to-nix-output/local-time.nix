args @ { fetchurl, ... }:
rec {
  baseName = ''local-time'';
  version = ''20170124-git'';

  description = ''A library for manipulating dates and times, based on a paper by Erik Naggum'';

  deps = [ args."cl-fad" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/local-time/2017-01-24/local-time-20170124-git.tgz'';
    sha256 = ''0nf21bhclr2cwpflf733wn6hr6mcz94dr796jk91f0ck28nf7ab1'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/local-time[.]asd${"$"}' |
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
/* (SYSTEM local-time DESCRIPTION A library for manipulating dates and times, based on a paper by Erik Naggum SHA256
    0nf21bhclr2cwpflf733wn6hr6mcz94dr796jk91f0ck28nf7ab1 URL http://beta.quicklisp.org/archive/local-time/2017-01-24/local-time-20170124-git.tgz MD5
    b345e5e74186eeddb85233df91d0dfe9 NAME local-time TESTNAME NIL FILENAME local-time DEPS ((NAME cl-fad)) DEPENDENCIES (cl-fad) VERSION 20170124-git SIBLINGS
    (cl-postgres+local-time local-time.test)) */
