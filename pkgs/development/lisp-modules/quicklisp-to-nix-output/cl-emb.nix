args @ { fetchurl, ... }:
rec {
  baseName = ''cl-emb'';
  version = ''20170227-git'';

  description = ''A templating system for Common Lisp'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-emb/2017-02-27/cl-emb-20170227-git.tgz'';
    sha256 = ''03n97xvh3v8bz1p75v1vhryfkjm74v0cr5jwg4rakq9zkchhfk80'';
  };
    
  packageName = "cl-emb";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-emb[.]asd${"$"}' |
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
/* (SYSTEM cl-emb DESCRIPTION A templating system for Common Lisp SHA256 03n97xvh3v8bz1p75v1vhryfkjm74v0cr5jwg4rakq9zkchhfk80 URL
    http://beta.quicklisp.org/archive/cl-emb/2017-02-27/cl-emb-20170227-git.tgz MD5 01d850432cc2f8e920e50b4b36e42d42 NAME cl-emb TESTNAME NIL FILENAME cl-emb
    DEPS NIL DEPENDENCIES NIL VERSION 20170227-git SIBLINGS NIL) */
