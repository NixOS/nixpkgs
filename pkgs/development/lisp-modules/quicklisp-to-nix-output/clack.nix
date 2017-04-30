args @ { fetchurl, ... }:
rec {
  baseName = ''clack'';
  version = ''20170403-git'';

  description = ''Web application environment for Common Lisp'';

  deps = [ args."uiop" args."lack-util" args."lack-middleware-backtrace" args."lack" args."bordeaux-threads" args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clack/2017-04-03/clack-20170403-git.tgz'';
    sha256 = ''1n6rbiz5ybwr1fbzynlmqmx2di5kqxrsniqx9mzy7034hqpk54ss'';
  };

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
/* (SYSTEM clack DESCRIPTION Web application environment for Common Lisp SHA256 1n6rbiz5ybwr1fbzynlmqmx2di5kqxrsniqx9mzy7034hqpk54ss URL
    http://beta.quicklisp.org/archive/clack/2017-04-03/clack-20170403-git.tgz MD5 98643f671285c11e91d2c81d4c8fc52a NAME clack TESTNAME NIL FILENAME clack DEPS
    ((NAME uiop) (NAME lack-util) (NAME lack-middleware-backtrace) (NAME lack) (NAME bordeaux-threads) (NAME alexandria)) DEPENDENCIES
    (uiop lack-util lack-middleware-backtrace lack bordeaux-threads alexandria) VERSION 20170403-git SIBLINGS
    (clack-handler-fcgi clack-handler-hunchentoot clack-handler-toot clack-handler-wookie clack-socket clack-test clack-v1-compat t-clack-handler-fcgi
     t-clack-handler-hunchentoot t-clack-handler-toot t-clack-handler-wookie t-clack-v1-compat clack-middleware-auth-basic clack-middleware-clsql
     clack-middleware-csrf clack-middleware-dbi clack-middleware-oauth clack-middleware-postmodern clack-middleware-rucksack clack-session-store-dbi
     t-clack-middleware-auth-basic t-clack-middleware-csrf)) */
