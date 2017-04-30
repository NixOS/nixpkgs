args @ { fetchurl, ... }:
rec {
  baseName = ''dexador'';
  version = ''20170403-git'';

  description = ''Yet another HTTP client for Common Lisp'';

  deps = [ args."usocket" args."trivial-mimes" args."trivial-gray-streams" args."quri" args."fast-io" args."fast-http" args."cl-reexport" args."cl-ppcre" args."cl-cookie" args."cl-base64" args."cl+ssl" args."chunga" args."chipz" args."bordeaux-threads" args."babel" args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/dexador/2017-04-03/dexador-20170403-git.tgz'';
    sha256 = ''0lnz36215wccpjgvrv9r7fa1i94jcdyw6q3hlgx9h8b7pwdlcfbn'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/dexador[.]asd${"$"}' |
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
/* (SYSTEM dexador DESCRIPTION Yet another HTTP client for Common Lisp SHA256 0lnz36215wccpjgvrv9r7fa1i94jcdyw6q3hlgx9h8b7pwdlcfbn URL
    http://beta.quicklisp.org/archive/dexador/2017-04-03/dexador-20170403-git.tgz MD5 0330a50a117313dbe0ba3f136b0fa416 NAME dexador TESTNAME NIL FILENAME
    dexador DEPS
    ((NAME usocket) (NAME trivial-mimes) (NAME trivial-gray-streams) (NAME quri) (NAME fast-io) (NAME fast-http) (NAME cl-reexport) (NAME cl-ppcre)
     (NAME cl-cookie) (NAME cl-base64) (NAME cl+ssl) (NAME chunga) (NAME chipz) (NAME bordeaux-threads) (NAME babel) (NAME alexandria))
    DEPENDENCIES
    (usocket trivial-mimes trivial-gray-streams quri fast-io fast-http cl-reexport cl-ppcre cl-cookie cl-base64 cl+ssl chunga chipz bordeaux-threads babel
     alexandria)
    VERSION 20170403-git SIBLINGS (dexador-test)) */
