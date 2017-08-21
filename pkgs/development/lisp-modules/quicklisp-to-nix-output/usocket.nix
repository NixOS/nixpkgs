args @ { fetchurl, ... }:
rec {
  baseName = ''usocket'';
  version = ''0.7.0.1'';

  description = ''Universal socket library for Common Lisp'';

  deps = [ args."split-sequence" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/usocket/2016-10-31/usocket-0.7.0.1.tgz'';
    sha256 = ''1mpcfawbzd72cd841bb0hmgx4kinnvcnazc7vym83gv5iy6lwif2'';
  };
    
  packageName = "usocket";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/usocket[.]asd${"$"}' |
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
/* (SYSTEM usocket DESCRIPTION Universal socket library for Common Lisp SHA256 1mpcfawbzd72cd841bb0hmgx4kinnvcnazc7vym83gv5iy6lwif2 URL
    http://beta.quicklisp.org/archive/usocket/2016-10-31/usocket-0.7.0.1.tgz MD5 1dcb027187679211f9d277ce99ca2a5a NAME usocket TESTNAME NIL FILENAME usocket
    DEPS ((NAME split-sequence FILENAME split-sequence)) DEPENDENCIES (split-sequence) VERSION 0.7.0.1 SIBLINGS (usocket-server usocket-test)) */
