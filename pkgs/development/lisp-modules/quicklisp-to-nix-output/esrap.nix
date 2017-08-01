args @ { fetchurl, ... }:
rec {
  baseName = ''esrap'';
  version = ''20170630-git'';

  description = ''A Packrat / Parsing Grammar / TDPL parser for Common Lisp.'';

  deps = [ args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/esrap/2017-06-30/esrap-20170630-git.tgz'';
    sha256 = ''172ph55kb3yr0gciybza1rbi6khlnz4vriijvcjkn6m79kdnk1xh'';
  };
    
  packageName = "esrap";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/esrap[.]asd${"$"}' |
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
/* (SYSTEM esrap DESCRIPTION A Packrat / Parsing Grammar / TDPL parser for Common Lisp. SHA256 172ph55kb3yr0gciybza1rbi6khlnz4vriijvcjkn6m79kdnk1xh URL
    http://beta.quicklisp.org/archive/esrap/2017-06-30/esrap-20170630-git.tgz MD5 bfabfebc5f5d49106df318ae2798ac45 NAME esrap TESTNAME NIL FILENAME esrap DEPS
    ((NAME alexandria FILENAME alexandria)) DEPENDENCIES (alexandria) VERSION 20170630-git SIBLINGS NIL) */
