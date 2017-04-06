args @ { fetchurl, ... }:
rec {
  baseName = ''lack-middleware-backtrace'';
  version = ''lack-20161204-git'';

  description = '''';

  deps = [ args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/lack/2016-12-04/lack-20161204-git.tgz'';
    sha256 = ''10bnpgbh5nk9lw1xywmvh5661rq91v8sp43ds53x98865ni7flnv'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/lack-middleware-backtrace[.]asd${"$"}' |
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
/* (SYSTEM lack-middleware-backtrace DESCRIPTION NIL SHA256 10bnpgbh5nk9lw1xywmvh5661rq91v8sp43ds53x98865ni7flnv URL
    http://beta.quicklisp.org/archive/lack/2016-12-04/lack-20161204-git.tgz MD5 bef444eeadf759226539318bee9f0ab5 NAME lack-middleware-backtrace TESTNAME NIL
    FILENAME lack-middleware-backtrace DEPS ((NAME uiop)) DEPENDENCIES (uiop) VERSION lack-20161204-git SIBLINGS
    (lack-component lack-middleware-accesslog lack-middleware-auth-basic lack-middleware-csrf lack-middleware-mount lack-middleware-session
     lack-middleware-static lack-request lack-response lack-session-store-dbi lack-session-store-redis lack-test lack-util-writer-stream lack-util lack
     t-lack-component t-lack-middleware-accesslog t-lack-middleware-auth-basic t-lack-middleware-backtrace t-lack-middleware-csrf t-lack-middleware-mount
     t-lack-middleware-session t-lack-middleware-static t-lack-request t-lack-session-store-dbi t-lack-session-store-redis t-lack-util t-lack)) */
