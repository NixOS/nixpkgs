args @ { fetchurl, ... }:
rec {
  baseName = ''cl-json'';
  version = ''20141217-git'';

  description = ''JSON in Lisp. JSON (JavaScript Object Notation) is a lightweight data-interchange format.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-json/2014-12-17/cl-json-20141217-git.tgz'';
    sha256 = ''00cfppyi6njsbpv1x03jcv4zwplg0q1138174l3wjkvi3gsql17g'';
  };
    
  packageName = "cl-json";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-json[.]asd${"$"}' |
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
/* (SYSTEM cl-json DESCRIPTION JSON in Lisp. JSON (JavaScript Object Notation) is a lightweight data-interchange format. SHA256
    00cfppyi6njsbpv1x03jcv4zwplg0q1138174l3wjkvi3gsql17g URL http://beta.quicklisp.org/archive/cl-json/2014-12-17/cl-json-20141217-git.tgz MD5
    9d873fa462b93c76d90642d8e3fb4881 NAME cl-json TESTNAME NIL FILENAME cl-json DEPS NIL DEPENDENCIES NIL VERSION 20141217-git SIBLINGS NIL) */
