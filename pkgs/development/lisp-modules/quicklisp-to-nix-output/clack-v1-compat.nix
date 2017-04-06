args @ { fetchurl, ... }:
rec {
  baseName = ''clack-v1-compat'';
  version = ''clack-20170403-git'';

  description = '''';

  deps = [ args."uiop" args."trivial-types" args."trivial-mimes" args."trivial-backtrace" args."split-sequence" args."quri" args."marshal" args."local-time" args."lack-util" args."lack" args."ironclad" args."http-body" args."flexi-streams" args."cl-syntax-annot" args."cl-ppcre" args."cl-base64" args."circular-streams" args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clack/2017-04-03/clack-20170403-git.tgz'';
    sha256 = ''1n6rbiz5ybwr1fbzynlmqmx2di5kqxrsniqx9mzy7034hqpk54ss'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/clack-v1-compat[.]asd${"$"}' |
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
/* (SYSTEM clack-v1-compat DESCRIPTION NIL SHA256 1n6rbiz5ybwr1fbzynlmqmx2di5kqxrsniqx9mzy7034hqpk54ss URL
    http://beta.quicklisp.org/archive/clack/2017-04-03/clack-20170403-git.tgz MD5 98643f671285c11e91d2c81d4c8fc52a NAME clack-v1-compat TESTNAME NIL FILENAME
    clack-v1-compat DEPS
    ((NAME uiop) (NAME trivial-types) (NAME trivial-mimes) (NAME trivial-backtrace) (NAME split-sequence) (NAME quri) (NAME marshal) (NAME local-time)
     (NAME lack-util) (NAME lack) (NAME ironclad) (NAME http-body) (NAME flexi-streams) (NAME cl-syntax-annot) (NAME cl-ppcre) (NAME cl-base64)
     (NAME circular-streams) (NAME alexandria))
    DEPENDENCIES
    (uiop trivial-types trivial-mimes trivial-backtrace split-sequence quri marshal local-time lack-util lack ironclad http-body flexi-streams cl-syntax-annot
     cl-ppcre cl-base64 circular-streams alexandria)
    VERSION clack-20170403-git SIBLINGS
    (clack-handler-fcgi clack-handler-hunchentoot clack-handler-toot clack-handler-wookie clack-socket clack-test clack t-clack-handler-fcgi
     t-clack-handler-hunchentoot t-clack-handler-toot t-clack-handler-wookie t-clack-v1-compat clack-middleware-auth-basic clack-middleware-clsql
     clack-middleware-csrf clack-middleware-dbi clack-middleware-oauth clack-middleware-postmodern clack-middleware-rucksack clack-session-store-dbi
     t-clack-middleware-auth-basic t-clack-middleware-csrf)) */
