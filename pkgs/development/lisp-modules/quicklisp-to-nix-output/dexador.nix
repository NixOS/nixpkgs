args @ { fetchurl, ... }:
rec {
  baseName = ''dexador'';
  version = ''20170725-git'';

  description = ''Yet another HTTP client for Common Lisp'';

  deps = [ args."usocket" args."trivial-mimes" args."trivial-gray-streams" args."quri" args."fast-io" args."fast-http" args."cl-reexport" args."cl-ppcre" args."cl-cookie" args."cl-base64" args."cl+ssl" args."chunga" args."chipz" args."bordeaux-threads" args."babel" args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/dexador/2017-07-25/dexador-20170725-git.tgz'';
    sha256 = ''1x5jw07ydvc7rdw4jyzf3zb2dg2mspbkp9ysjaqpxlvkpdmqdmyl'';
  };
    
  packageName = "dexador";

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
/* (SYSTEM dexador DESCRIPTION Yet another HTTP client for Common Lisp SHA256 1x5jw07ydvc7rdw4jyzf3zb2dg2mspbkp9ysjaqpxlvkpdmqdmyl URL
    http://beta.quicklisp.org/archive/dexador/2017-07-25/dexador-20170725-git.tgz MD5 1ab5cda1ba8d5c81859349e6a5b99b29 NAME dexador TESTNAME NIL FILENAME
    dexador DEPS
    ((NAME usocket FILENAME usocket) (NAME trivial-mimes FILENAME trivial-mimes) (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME quri FILENAME quri) (NAME fast-io FILENAME fast-io) (NAME fast-http FILENAME fast-http) (NAME cl-reexport FILENAME cl-reexport)
     (NAME cl-ppcre FILENAME cl-ppcre) (NAME cl-cookie FILENAME cl-cookie) (NAME cl-base64 FILENAME cl-base64) (NAME cl+ssl FILENAME cl+ssl)
     (NAME chunga FILENAME chunga) (NAME chipz FILENAME chipz) (NAME bordeaux-threads FILENAME bordeaux-threads) (NAME babel FILENAME babel)
     (NAME alexandria FILENAME alexandria))
    DEPENDENCIES
    (usocket trivial-mimes trivial-gray-streams quri fast-io fast-http cl-reexport cl-ppcre cl-cookie cl-base64 cl+ssl chunga chipz bordeaux-threads babel
     alexandria)
    VERSION 20170725-git SIBLINGS (dexador-test)) */
