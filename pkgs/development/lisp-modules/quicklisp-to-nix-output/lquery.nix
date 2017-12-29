args @ { fetchurl, ... }:
rec {
  baseName = ''lquery'';
  version = ''20170630-git'';

  description = ''A library to allow jQuery-like HTML/DOM manipulation.'';

  deps = [ args."plump" args."form-fiddle" args."clss" args."array-utils" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/lquery/2017-06-30/lquery-20170630-git.tgz'';
    sha256 = ''19lpzjidg31lw61b78vdsqzrsdw2js4a9s7zzr5049jpzbspszjm'';
  };
    
  packageName = "lquery";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/lquery[.]asd${"$"}' |
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
/* (SYSTEM lquery DESCRIPTION A library to allow jQuery-like HTML/DOM manipulation. SHA256 19lpzjidg31lw61b78vdsqzrsdw2js4a9s7zzr5049jpzbspszjm URL
    http://beta.quicklisp.org/archive/lquery/2017-06-30/lquery-20170630-git.tgz MD5 aeb03cb5174d682092683da488531a9c NAME lquery TESTNAME NIL FILENAME lquery
    DEPS ((NAME plump FILENAME plump) (NAME form-fiddle FILENAME form-fiddle) (NAME clss FILENAME clss) (NAME array-utils FILENAME array-utils)) DEPENDENCIES
    (plump form-fiddle clss array-utils) VERSION 20170630-git SIBLINGS (lquery-test)) */
