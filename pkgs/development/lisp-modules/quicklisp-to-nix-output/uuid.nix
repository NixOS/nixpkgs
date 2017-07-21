args @ { fetchurl, ... }:
rec {
  baseName = ''uuid'';
  version = ''20130813-git'';

  description = ''UUID Generation'';

  deps = [ args."ironclad" args."trivial-utf-8" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/uuid/2013-08-13/uuid-20130813-git.tgz'';
    sha256 = ''1ph88gizpkxqigfrkgmq0vd3qkgpxd9zjy6qyr0ic4xdyyymg1hf'';
  };
    
  packageName = "uuid";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/uuid[.]asd${"$"}' |
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
/* (SYSTEM uuid DESCRIPTION UUID Generation SHA256 1ph88gizpkxqigfrkgmq0vd3qkgpxd9zjy6qyr0ic4xdyyymg1hf URL
    http://beta.quicklisp.org/archive/uuid/2013-08-13/uuid-20130813-git.tgz MD5 e9029d9437573ec2ffa2b474adf95daf NAME uuid TESTNAME NIL FILENAME uuid DEPS
    ((NAME ironclad FILENAME ironclad) (NAME trivial-utf-8 FILENAME trivial-utf-8)) DEPENDENCIES (ironclad trivial-utf-8) VERSION 20130813-git SIBLINGS NIL) */
