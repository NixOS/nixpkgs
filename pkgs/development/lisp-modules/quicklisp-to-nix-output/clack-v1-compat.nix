args @ { fetchurl, ... }:
rec {
  baseName = ''clack-v1-compat'';
  version = ''clack-20170227-git'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clack/2017-02-27/clack-20170227-git.tgz'';
    sha256 = ''1sm6iamghpzmrv0h375y2famdngx62ml5dw424896kixxfyr923x'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/clack-v1-compat[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM clack-v1-compat DESCRIPTION NIL SHA256 1sm6iamghpzmrv0h375y2famdngx62ml5dw424896kixxfyr923x URL
    http://beta.quicklisp.org/archive/clack/2017-02-27/clack-20170227-git.tgz MD5 2264b62c2de992d12829053e8e5f9101 NAME clack-v1-compat TESTNAME NIL FILENAME
    clack-v1-compat DEPS NIL DEPENDENCIES NIL VERSION clack-20170227-git SIBLINGS
    (clack-handler-fcgi clack-handler-hunchentoot clack-handler-toot clack-handler-wookie clack-socket clack-test clack t-clack-handler-fcgi
     t-clack-handler-hunchentoot t-clack-handler-toot t-clack-handler-wookie t-clack-v1-compat clack-middleware-auth-basic clack-middleware-clsql
     clack-middleware-csrf clack-middleware-dbi clack-middleware-oauth clack-middleware-postmodern clack-middleware-rucksack clack-session-store-dbi
     t-clack-middleware-auth-basic t-clack-middleware-csrf)) */
