args @ { fetchurl, ... }:
rec {
  baseName = ''quri'';
  version = ''20161204-git'';

  description = ''Yet another URI library for Common Lisp'';

  deps = [ args."split-sequence" args."cl-utilities" args."babel" args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/quri/2016-12-04/quri-20161204-git.tgz'';
    sha256 = ''14if83kd2mv68p4g4ch2w796w3micpzv40z7xrcwzwj64wngwabv'';
  };
    
  packageName = "quri";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/quri[.]asd${"$"}' |
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
/* (SYSTEM quri DESCRIPTION Yet another URI library for Common Lisp SHA256 14if83kd2mv68p4g4ch2w796w3micpzv40z7xrcwzwj64wngwabv URL
    http://beta.quicklisp.org/archive/quri/2016-12-04/quri-20161204-git.tgz MD5 8c87e99d4f7308d83aab361a6e36508a NAME quri TESTNAME NIL FILENAME quri DEPS
    ((NAME split-sequence FILENAME split-sequence) (NAME cl-utilities FILENAME cl-utilities) (NAME babel FILENAME babel) (NAME alexandria FILENAME alexandria))
    DEPENDENCIES (split-sequence cl-utilities babel alexandria) VERSION 20161204-git SIBLINGS (quri-test)) */
