args @ { fetchurl, ... }:
rec {
  baseName = ''alexandria'';
  version = ''20170630-git'';

  description = ''Alexandria is a collection of portable public domain utilities.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/alexandria/2017-06-30/alexandria-20170630-git.tgz'';
    sha256 = ''1ch7987ijs5gz5dk3i02bqgb2bn7s9p3sfsrwq4fp1sxykwr9fis'';
  };
    
  packageName = "alexandria";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/alexandria[.]asd${"$"}' |
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
/* (SYSTEM alexandria DESCRIPTION Alexandria is a collection of portable public domain utilities. SHA256 1ch7987ijs5gz5dk3i02bqgb2bn7s9p3sfsrwq4fp1sxykwr9fis
    URL http://beta.quicklisp.org/archive/alexandria/2017-06-30/alexandria-20170630-git.tgz MD5 ce5427881c909981192f870cb52ff59f NAME alexandria TESTNAME NIL
    FILENAME alexandria DEPS NIL DEPENDENCIES NIL VERSION 20170630-git SIBLINGS (alexandria-tests)) */
