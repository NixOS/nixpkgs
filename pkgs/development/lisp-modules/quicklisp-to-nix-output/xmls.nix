args @ { fetchurl, ... }:
rec {
  baseName = ''xmls'';
  version = ''1.7'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/xmls/2015-04-07/xmls-1.7.tgz'';
    sha256 = ''1pch221g5jv02rb21ly9ik4cmbzv8ca6bnyrs4s0yfrrq0ji406b'';
  };
    
  packageName = "xmls";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/xmls[.]asd${"$"}' |
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
/* (SYSTEM xmls DESCRIPTION NIL SHA256 1pch221g5jv02rb21ly9ik4cmbzv8ca6bnyrs4s0yfrrq0ji406b URL http://beta.quicklisp.org/archive/xmls/2015-04-07/xmls-1.7.tgz
    MD5 697c9f49a60651b759e24ea0c1eb1cfe NAME xmls TESTNAME NIL FILENAME xmls DEPS NIL DEPENDENCIES NIL VERSION 1.7 SIBLINGS NIL) */
