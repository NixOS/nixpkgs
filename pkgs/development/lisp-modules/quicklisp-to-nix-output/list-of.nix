args @ { fetchurl, ... }:
rec {
  baseName = ''list-of'';
  version = ''asdf-finalizers-20170403-git'';

  description = ''magic list-of deftype'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/asdf-finalizers/2017-04-03/asdf-finalizers-20170403-git.tgz'';
    sha256 = ''1w2ka0123icbjba7ngdd6h93j72g236h6jw4bsmvsak69fj0ybxj'';
  };
    
  packageName = "list-of";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/list-of[.]asd${"$"}' |
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
/* (SYSTEM list-of DESCRIPTION magic list-of deftype SHA256 1w2ka0123icbjba7ngdd6h93j72g236h6jw4bsmvsak69fj0ybxj URL
    http://beta.quicklisp.org/archive/asdf-finalizers/2017-04-03/asdf-finalizers-20170403-git.tgz MD5 a9e3c960e6b6fdbd69640b520ef8044b NAME list-of TESTNAME
    NIL FILENAME list-of DEPS NIL DEPENDENCIES NIL VERSION asdf-finalizers-20170403-git SIBLINGS (asdf-finalizers-test asdf-finalizers)) */
