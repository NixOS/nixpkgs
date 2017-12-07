args @ { fetchurl, ... }:
rec {
  baseName = ''lparallel'';
  version = ''20160825-git'';

  description = ''Parallelism for Common Lisp'';

  deps = [ args."bordeaux-threads" args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/lparallel/2016-08-25/lparallel-20160825-git.tgz'';
    sha256 = ''0wwwwszbj6m0b2rsp8mpn4m6y7xk448bw8fb7gy0ggmsdfgchfr1'';
  };
    
  packageName = "lparallel";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/lparallel[.]asd${"$"}' |
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
/* (SYSTEM lparallel DESCRIPTION Parallelism for Common Lisp SHA256 0wwwwszbj6m0b2rsp8mpn4m6y7xk448bw8fb7gy0ggmsdfgchfr1 URL
    http://beta.quicklisp.org/archive/lparallel/2016-08-25/lparallel-20160825-git.tgz MD5 6393e8d0c0cc9ed1c88b6e7cca8de5df NAME lparallel TESTNAME NIL FILENAME
    lparallel DEPS ((NAME bordeaux-threads FILENAME bordeaux-threads) (NAME alexandria FILENAME alexandria)) DEPENDENCIES (bordeaux-threads alexandria) VERSION
    20160825-git SIBLINGS (lparallel-bench lparallel-test)) */
