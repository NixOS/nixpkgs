args @ { fetchurl, ... }:
rec {
  baseName = ''clack'';
  version = ''20170630-git'';

  description = ''Web application environment for Common Lisp'';

  deps = [ args."uiop" args."lack-util" args."lack-middleware-backtrace" args."lack" args."bordeaux-threads" args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clack/2017-06-30/clack-20170630-git.tgz'';
    sha256 = ''1z3xrwldfzd4nagk2d0gw5hspnr35r6kh19ksqr3kyf6wpn2lybg'';
  };
    
  packageName = "clack";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/clack[.]asd${"$"}' |
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
/* (SYSTEM clack DESCRIPTION Web application environment for Common Lisp SHA256 1z3xrwldfzd4nagk2d0gw5hspnr35r6kh19ksqr3kyf6wpn2lybg URL
    http://beta.quicklisp.org/archive/clack/2017-06-30/clack-20170630-git.tgz MD5 845b25a3cc6f3a1ee1dbd6de73dfb815 NAME clack TESTNAME NIL FILENAME clack DEPS
    ((NAME uiop FILENAME uiop) (NAME lack-util FILENAME lack-util) (NAME lack-middleware-backtrace FILENAME lack-middleware-backtrace)
     (NAME lack FILENAME lack) (NAME bordeaux-threads FILENAME bordeaux-threads) (NAME alexandria FILENAME alexandria))
    DEPENDENCIES (uiop lack-util lack-middleware-backtrace lack bordeaux-threads alexandria) VERSION 20170630-git SIBLINGS
    (clack-handler-fcgi clack-handler-hunchentoot clack-handler-toot clack-handler-wookie clack-socket clack-test clack-v1-compat t-clack-handler-fcgi
     t-clack-handler-hunchentoot t-clack-handler-toot t-clack-handler-wookie t-clack-v1-compat clack-middleware-auth-basic clack-middleware-clsql
     clack-middleware-csrf clack-middleware-dbi clack-middleware-oauth clack-middleware-postmodern clack-middleware-rucksack clack-session-store-dbi
     t-clack-middleware-auth-basic t-clack-middleware-csrf)) */
