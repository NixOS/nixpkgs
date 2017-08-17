args @ { fetchurl, ... }:
rec {
  baseName = ''fast-http'';
  version = ''20170630-git'';

  description = ''A fast HTTP protocol parser in Common Lisp'';

  deps = [ args."xsubseq" args."smart-buffer" args."proc-parse" args."cl-utilities" args."babel" args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/fast-http/2017-06-30/fast-http-20170630-git.tgz'';
    sha256 = ''0fkqwbwqc9a783ynjbszimcrannpqq4ja6wcf8ybgizr4zvsgj29'';
  };
    
  packageName = "fast-http";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/fast-http[.]asd${"$"}' |
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
/* (SYSTEM fast-http DESCRIPTION A fast HTTP protocol parser in Common Lisp SHA256 0fkqwbwqc9a783ynjbszimcrannpqq4ja6wcf8ybgizr4zvsgj29 URL
    http://beta.quicklisp.org/archive/fast-http/2017-06-30/fast-http-20170630-git.tgz MD5 d117d59c1f71965e0c32b19e6790cf9a NAME fast-http TESTNAME NIL FILENAME
    fast-http DEPS
    ((NAME xsubseq FILENAME xsubseq) (NAME smart-buffer FILENAME smart-buffer) (NAME proc-parse FILENAME proc-parse) (NAME cl-utilities FILENAME cl-utilities)
     (NAME babel FILENAME babel) (NAME alexandria FILENAME alexandria))
    DEPENDENCIES (xsubseq smart-buffer proc-parse cl-utilities babel alexandria) VERSION 20170630-git SIBLINGS (fast-http-test)) */
