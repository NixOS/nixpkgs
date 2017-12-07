args @ { fetchurl, ... }:
rec {
  baseName = ''drakma'';
  version = ''v2.0.3'';

  description = ''Full-featured http/https client based on usocket'';

  deps = [ args."usocket" args."puri" args."flexi-streams" args."cl-ppcre" args."cl-base64" args."cl+ssl" args."chunga" args."chipz" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/drakma/2017-06-30/drakma-v2.0.3.tgz'';
    sha256 = ''1xbbwd2gg17pq03bblj6imh7lq39z2w3yix6fm25509gyhs76ymd'';
  };
    
  packageName = "drakma";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/drakma[.]asd${"$"}' |
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
/* (SYSTEM drakma DESCRIPTION Full-featured http/https client based on usocket SHA256 1xbbwd2gg17pq03bblj6imh7lq39z2w3yix6fm25509gyhs76ymd URL
    http://beta.quicklisp.org/archive/drakma/2017-06-30/drakma-v2.0.3.tgz MD5 3578c67b445cf982414ff78b2fb8d295 NAME drakma TESTNAME NIL FILENAME drakma DEPS
    ((NAME usocket FILENAME usocket) (NAME puri FILENAME puri) (NAME flexi-streams FILENAME flexi-streams) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-base64 FILENAME cl-base64) (NAME cl+ssl FILENAME cl+ssl) (NAME chunga FILENAME chunga) (NAME chipz FILENAME chipz))
    DEPENDENCIES (usocket puri flexi-streams cl-ppcre cl-base64 cl+ssl chunga chipz) VERSION v2.0.3 SIBLINGS (drakma-test)) */
