args @ { fetchurl, ... }:
rec {
  baseName = ''woo'';
  version = ''20170725-git'';

  description = ''An asynchronous HTTP server written in Common Lisp'';

  deps = [ args."vom" args."uiop" args."trivial-utf-8" args."swap-bytes" args."static-vectors" args."smart-buffer" args."quri" args."lev" args."fast-io" args."fast-http" args."clack-socket" args."cffi-grovel" args."cffi" args."bordeaux-threads" args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/woo/2017-07-25/woo-20170725-git.tgz'';
    sha256 = ''11cnqd058mjhkgxppsivbmd687429r4b62v7z5iav0wpha78qfgg'';
  };
    
  packageName = "woo";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/woo[.]asd${"$"}' |
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
/* (SYSTEM woo DESCRIPTION An asynchronous HTTP server written in Common Lisp SHA256 11cnqd058mjhkgxppsivbmd687429r4b62v7z5iav0wpha78qfgg URL
    http://beta.quicklisp.org/archive/woo/2017-07-25/woo-20170725-git.tgz MD5 bd901d8dfa7df3d19c6da73ea101f65b NAME woo TESTNAME NIL FILENAME woo DEPS
    ((NAME vom FILENAME vom) (NAME uiop FILENAME uiop) (NAME trivial-utf-8 FILENAME trivial-utf-8) (NAME swap-bytes FILENAME swap-bytes)
     (NAME static-vectors FILENAME static-vectors) (NAME smart-buffer FILENAME smart-buffer) (NAME quri FILENAME quri) (NAME lev FILENAME lev)
     (NAME fast-io FILENAME fast-io) (NAME fast-http FILENAME fast-http) (NAME clack-socket FILENAME clack-socket) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cffi FILENAME cffi) (NAME bordeaux-threads FILENAME bordeaux-threads) (NAME alexandria FILENAME alexandria))
    DEPENDENCIES
    (vom uiop trivial-utf-8 swap-bytes static-vectors smart-buffer quri lev fast-io fast-http clack-socket cffi-grovel cffi bordeaux-threads alexandria)
    VERSION 20170725-git SIBLINGS (clack-handler-woo woo-test)) */
