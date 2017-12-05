args @ { fetchurl, ... }:
rec {
  baseName = ''_3bmd'';
  version = ''20161204-git'';

  description = ''markdown processor in CL using esrap parser.'';

  deps = [ args."split-sequence" args."esrap" args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/3bmd/2016-12-04/3bmd-20161204-git.tgz'';
    sha256 = ''158rymq6ra9ipmkqrqmgr4ay5m46cdxxha03622svllhyf7xzypx'';
  };
    
  packageName = "3bmd";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/3bmd[.]asd${"$"}' |
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
/* (SYSTEM 3bmd DESCRIPTION markdown processor in CL using esrap parser. SHA256 158rymq6ra9ipmkqrqmgr4ay5m46cdxxha03622svllhyf7xzypx URL
    http://beta.quicklisp.org/archive/3bmd/2016-12-04/3bmd-20161204-git.tgz MD5 b80864c74437e0cfb66663e9bbf08fed NAME 3bmd TESTNAME NIL FILENAME _3bmd DEPS
    ((NAME split-sequence FILENAME split-sequence) (NAME esrap FILENAME esrap) (NAME alexandria FILENAME alexandria)) DEPENDENCIES
    (split-sequence esrap alexandria) VERSION 20161204-git SIBLINGS
    (3bmd-ext-code-blocks 3bmd-ext-definition-lists 3bmd-ext-tables 3bmd-ext-wiki-links 3bmd-youtube-tests 3bmd-youtube)) */
