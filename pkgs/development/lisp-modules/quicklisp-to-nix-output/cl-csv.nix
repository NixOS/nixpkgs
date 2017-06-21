args @ { fetchurl, ... }:
rec {
  baseName = ''cl-csv'';
  version = ''20170403-git'';

  description = ''Facilities for reading and writing CSV format files'';

  deps = [ args."iterate" args."cl-interpol" args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-csv/2017-04-03/cl-csv-20170403-git.tgz'';
    sha256 = ''1mz0hr0r7yxw1dzdbaqzxabmipp286zc6aglni9f46isjwmqpy6h'';
  };
    
  packageName = "cl-csv";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-csv[.]asd${"$"}' |
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
/* (SYSTEM cl-csv DESCRIPTION Facilities for reading and writing CSV format files SHA256 1mz0hr0r7yxw1dzdbaqzxabmipp286zc6aglni9f46isjwmqpy6h URL
    http://beta.quicklisp.org/archive/cl-csv/2017-04-03/cl-csv-20170403-git.tgz MD5 1e71a90c5057371fab044d440c39f0a3 NAME cl-csv TESTNAME NIL FILENAME cl-csv
    DEPS ((NAME iterate FILENAME iterate) (NAME cl-interpol FILENAME cl-interpol) (NAME alexandria FILENAME alexandria)) DEPENDENCIES
    (iterate cl-interpol alexandria) VERSION 20170403-git SIBLINGS (cl-csv-clsql cl-csv-data-table)) */
