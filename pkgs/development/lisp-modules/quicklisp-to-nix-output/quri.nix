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

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/quri[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM quri DESCRIPTION Yet another URI library for Common Lisp SHA256 14if83kd2mv68p4g4ch2w796w3micpzv40z7xrcwzwj64wngwabv URL
    http://beta.quicklisp.org/archive/quri/2016-12-04/quri-20161204-git.tgz MD5 8c87e99d4f7308d83aab361a6e36508a NAME quri TESTNAME NIL FILENAME quri DEPS
    ((NAME split-sequence) (NAME cl-utilities) (NAME babel) (NAME alexandria)) DEPENDENCIES (split-sequence cl-utilities babel alexandria) VERSION 20161204-git
    SIBLINGS (quri-test)) */
