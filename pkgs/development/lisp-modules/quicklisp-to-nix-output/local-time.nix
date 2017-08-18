args @ { fetchurl, ... }:
rec {
  baseName = ''local-time'';
  version = ''20170725-git'';

  description = ''A library for manipulating dates and times, based on a paper by Erik Naggum'';

  deps = [ args."cl-fad" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/local-time/2017-07-25/local-time-20170725-git.tgz'';
    sha256 = ''05axwla93m5jml9lw6ljwzjhcl8pshfzxyqkvyj1w5l9klh569p9'';
  };
    
  packageName = "local-time";

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
    05axwla93m5jml9lw6ljwzjhcl8pshfzxyqkvyj1w5l9klh569p9 URL http://beta.quicklisp.org/archive/local-time/2017-07-25/local-time-20170725-git.tgz MD5
    77a79ed1036bc3547f5174f2256c8e93 NAME local-time TESTNAME NIL FILENAME local-time DEPS ((NAME cl-fad FILENAME cl-fad)) DEPENDENCIES (cl-fad) VERSION
    20170725-git SIBLINGS (cl-postgres+local-time local-time.test)) */
