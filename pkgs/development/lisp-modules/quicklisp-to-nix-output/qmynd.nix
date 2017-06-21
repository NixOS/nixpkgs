args @ { fetchurl, ... }:
rec {
  baseName = ''qmynd'';
  version = ''20160208-git'';

  description = ''MySQL Native Driver'';

  deps = [ args."usocket" args."trivial-gray-streams" args."salza2" args."list-of" args."ironclad" args."flexi-streams" args."cl+ssl" args."chipz" args."babel" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/qmynd/2016-02-08/qmynd-20160208-git.tgz'';
    sha256 = ''0x9ml8id3s8l0rsa108bcs5lmyhb2y5a5p7s9ppvmqd4cgxnramq'';
  };
    
  packageName = "qmynd";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/qmynd[.]asd${"$"}' |
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
/* (SYSTEM qmynd DESCRIPTION MySQL Native Driver SHA256 0x9ml8id3s8l0rsa108bcs5lmyhb2y5a5p7s9ppvmqd4cgxnramq URL
    http://beta.quicklisp.org/archive/qmynd/2016-02-08/qmynd-20160208-git.tgz MD5 9483ba5330a4240a9d5a8016c16a0084 NAME qmynd TESTNAME NIL FILENAME qmynd DEPS
    ((NAME usocket FILENAME usocket) (NAME trivial-gray-streams FILENAME trivial-gray-streams) (NAME salza2 FILENAME salza2) (NAME list-of FILENAME list-of)
     (NAME ironclad FILENAME ironclad) (NAME flexi-streams FILENAME flexi-streams) (NAME cl+ssl FILENAME cl+ssl) (NAME chipz FILENAME chipz)
     (NAME babel FILENAME babel))
    DEPENDENCIES (usocket trivial-gray-streams salza2 list-of ironclad flexi-streams cl+ssl chipz babel) VERSION 20160208-git SIBLINGS (qmynd-test)) */
