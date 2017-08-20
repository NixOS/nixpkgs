args @ { fetchurl, ... }:
rec {
  baseName = ''clx'';
  version = ''20170630-git'';

  description = ''An implementation of the X Window System protocol in Lisp.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clx/2017-06-30/clx-20170630-git.tgz'';
    sha256 = ''0di8h3galjylgmy30qqwa4q8mb5505rcag0y4ia7mv7sls51jbp7'';
  };
    
  packageName = "clx";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/clx[.]asd${"$"}' |
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
/* (SYSTEM clx DESCRIPTION An implementation of the X Window System protocol in Lisp. SHA256 0di8h3galjylgmy30qqwa4q8mb5505rcag0y4ia7mv7sls51jbp7 URL
    http://beta.quicklisp.org/archive/clx/2017-06-30/clx-20170630-git.tgz MD5 ccfec3f35979df3bead0b73adc1d798a NAME clx TESTNAME NIL FILENAME clx DEPS NIL
    DEPENDENCIES NIL VERSION 20170630-git SIBLINGS NIL) */
