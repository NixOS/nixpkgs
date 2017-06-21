args @ { fetchurl, ... }:
rec {
  baseName = ''alexandria'';
  version = ''20170516-git'';

  description = ''Alexandria is a collection of portable public domain utilities.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/alexandria/2017-05-16/alexandria-20170516-git.tgz'';
    sha256 = ''0yi2lxy9w7pmw4k7yzp82m6cpambclji7c7km3lx0hazv838rw82'';
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
/* (SYSTEM alexandria DESCRIPTION Alexandria is a collection of portable public domain utilities. SHA256 0yi2lxy9w7pmw4k7yzp82m6cpambclji7c7km3lx0hazv838rw82
    URL http://beta.quicklisp.org/archive/alexandria/2017-05-16/alexandria-20170516-git.tgz MD5 9234737872493dd82d2da9cadf6a1484 NAME alexandria TESTNAME NIL
    FILENAME alexandria DEPS NIL DEPENDENCIES NIL VERSION 20170516-git SIBLINGS (alexandria-tests)) */
