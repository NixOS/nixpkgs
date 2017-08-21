args @ { fetchurl, ... }:
rec {
  baseName = ''clack-v1-compat'';
  version = ''clack-20170630-git'';

  description = '''';

  deps = [ args."uiop" args."trivial-types" args."trivial-mimes" args."trivial-backtrace" args."split-sequence" args."quri" args."marshal" args."local-time" args."lack-util" args."lack" args."ironclad" args."http-body" args."flexi-streams" args."cl-syntax-annot" args."cl-ppcre" args."cl-base64" args."circular-streams" args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clack/2017-06-30/clack-20170630-git.tgz'';
    sha256 = ''1z3xrwldfzd4nagk2d0gw5hspnr35r6kh19ksqr3kyf6wpn2lybg'';
  };
    
  packageName = "clack-v1-compat";

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
/* (SYSTEM clack-v1-compat DESCRIPTION NIL SHA256 1z3xrwldfzd4nagk2d0gw5hspnr35r6kh19ksqr3kyf6wpn2lybg URL
    http://beta.quicklisp.org/archive/clack/2017-06-30/clack-20170630-git.tgz MD5 845b25a3cc6f3a1ee1dbd6de73dfb815 NAME clack-v1-compat TESTNAME NIL FILENAME
    clack-v1-compat DEPS
    ((NAME uiop FILENAME uiop) (NAME trivial-types FILENAME trivial-types) (NAME trivial-mimes FILENAME trivial-mimes)
     (NAME trivial-backtrace FILENAME trivial-backtrace) (NAME split-sequence FILENAME split-sequence) (NAME quri FILENAME quri)
     (NAME marshal FILENAME marshal) (NAME local-time FILENAME local-time) (NAME lack-util FILENAME lack-util) (NAME lack FILENAME lack)
     (NAME ironclad FILENAME ironclad) (NAME http-body FILENAME http-body) (NAME flexi-streams FILENAME flexi-streams)
     (NAME cl-syntax-annot FILENAME cl-syntax-annot) (NAME cl-ppcre FILENAME cl-ppcre) (NAME cl-base64 FILENAME cl-base64)
     (NAME circular-streams FILENAME circular-streams) (NAME alexandria FILENAME alexandria))
    DEPENDENCIES
    (uiop trivial-types trivial-mimes trivial-backtrace split-sequence quri marshal local-time lack-util lack ironclad http-body flexi-streams cl-syntax-annot
     cl-ppcre cl-base64 circular-streams alexandria)
    VERSION clack-20170630-git SIBLINGS
    (clack-handler-fcgi clack-handler-hunchentoot clack-handler-toot clack-handler-wookie clack-socket clack-test clack t-clack-handler-fcgi
     t-clack-handler-hunchentoot t-clack-handler-toot t-clack-handler-wookie t-clack-v1-compat clack-middleware-auth-basic clack-middleware-clsql
     clack-middleware-csrf clack-middleware-dbi clack-middleware-oauth clack-middleware-postmodern clack-middleware-rucksack clack-session-store-dbi
     t-clack-middleware-auth-basic t-clack-middleware-csrf)) */
