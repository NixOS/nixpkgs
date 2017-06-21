args @ { fetchurl, ... }:
rec {
  baseName = ''hu_dot_dwim_dot_asdf'';
  version = ''20170516-darcs'';

  description = ''Various ASDF extensions such as attached test and documentation system, explicit development support, etc.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/hu.dwim.asdf/2017-05-16/hu.dwim.asdf-20170516-darcs.tgz'';
    sha256 = ''0ky8xby4zkqslgcb4glns8g4v8fzijx4v1888kil3ncxbvz0aqpw'';
  };
    
  packageName = "hu.dwim.asdf";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/hu.dwim.asdf[.]asd${"$"}' |
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
/* (SYSTEM hu.dwim.asdf DESCRIPTION Various ASDF extensions such as attached test and documentation system, explicit development support, etc. SHA256
    0ky8xby4zkqslgcb4glns8g4v8fzijx4v1888kil3ncxbvz0aqpw URL http://beta.quicklisp.org/archive/hu.dwim.asdf/2017-05-16/hu.dwim.asdf-20170516-darcs.tgz MD5
    041447371d36ceb17f58854671c052f1 NAME hu.dwim.asdf TESTNAME NIL FILENAME hu_dot_dwim_dot_asdf DEPS NIL DEPENDENCIES NIL VERSION 20170516-darcs SIBLINGS
    (hu.dwim.asdf.documentation)) */
