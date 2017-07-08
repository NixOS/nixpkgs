args @ { fetchurl, ... }:
rec {
  baseName = ''mssql'';
  version = ''cl-20131003-git'';

  description = '''';

  deps = [ args."cffi" args."garbage-pools" args."iterate" args."parse-number" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-mssql/2013-10-03/cl-mssql-20131003-git.tgz'';
    sha256 = ''1ykk8g4h3n21ich60l495v6h5pplx9hfs0kasz8myc5xv8ndljnk'';
  };
    
  packageName = "mssql";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/mssql[.]asd${"$"}' |
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
/* (SYSTEM mssql DESCRIPTION NIL SHA256 1ykk8g4h3n21ich60l495v6h5pplx9hfs0kasz8myc5xv8ndljnk URL
    http://beta.quicklisp.org/archive/cl-mssql/2013-10-03/cl-mssql-20131003-git.tgz MD5 3e9d85a3b0ae7e000723a857ce7c2d44 NAME mssql TESTNAME NIL FILENAME mssql
    DEPS ((NAME cffi FILENAME cffi) (NAME garbage-pools FILENAME garbage-pools) (NAME iterate FILENAME iterate) (NAME parse-number FILENAME parse-number))
    DEPENDENCIES (cffi garbage-pools iterate parse-number) VERSION cl-20131003-git SIBLINGS NIL) */
