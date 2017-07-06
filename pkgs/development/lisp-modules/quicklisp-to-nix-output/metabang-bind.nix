args @ { fetchurl, ... }:
rec {
  baseName = ''metabang-bind'';
  version = ''20170124-git'';

  description = ''Bind is a macro that generalizes multiple-value-bind, let, let*, destructuring-bind, structure and slot accessors, and a whole lot more.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/metabang-bind/2017-01-24/metabang-bind-20170124-git.tgz'';
    sha256 = ''1xyiyrc9c02ylg6b749h2ihn6922kb179x7k338dmglf4mpyqxwc'';
  };
    
  packageName = "metabang-bind";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/metabang-bind[.]asd${"$"}' |
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
/* (SYSTEM metabang-bind DESCRIPTION
    Bind is a macro that generalizes multiple-value-bind, let, let*, destructuring-bind, structure and slot accessors, and a whole lot more. SHA256
    1xyiyrc9c02ylg6b749h2ihn6922kb179x7k338dmglf4mpyqxwc URL http://beta.quicklisp.org/archive/metabang-bind/2017-01-24/metabang-bind-20170124-git.tgz MD5
    20c6a434308598ad7fa224d99f3bcbf6 NAME metabang-bind TESTNAME NIL FILENAME metabang-bind DEPS NIL DEPENDENCIES NIL VERSION 20170124-git SIBLINGS
    (metabang-bind-test)) */
