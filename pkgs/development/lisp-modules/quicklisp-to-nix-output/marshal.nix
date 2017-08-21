args @ { fetchurl, ... }:
rec {
  baseName = ''marshal'';
  version = ''cl-20170124-git'';

  description = ''marshal: Simple (de)serialization of Lisp datastructures.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-marshal/2017-01-24/cl-marshal-20170124-git.tgz'';
    sha256 = ''0z43m3jspl4c4fcbbxm58hxd9k69308pyijgj7grmq6mirkq664d'';
  };
    
  packageName = "marshal";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/marshal[.]asd${"$"}' |
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
/* (SYSTEM marshal DESCRIPTION marshal: Simple (de)serialization of Lisp datastructures. SHA256 0z43m3jspl4c4fcbbxm58hxd9k69308pyijgj7grmq6mirkq664d URL
    http://beta.quicklisp.org/archive/cl-marshal/2017-01-24/cl-marshal-20170124-git.tgz MD5 ebde1b0f1c1abeb409380884cc665351 NAME marshal TESTNAME NIL FILENAME
    marshal DEPS NIL DEPENDENCIES NIL VERSION cl-20170124-git SIBLINGS NIL) */
