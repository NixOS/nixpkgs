args @ { fetchurl, ... }:
rec {
  baseName = ''do-urlencode'';
  version = ''20130720-git'';

  description = ''Percent Encoding (aka URL Encoding) library'';

  deps = [ args."babel" args."babel-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/do-urlencode/2013-07-20/do-urlencode-20130720-git.tgz'';
    sha256 = ''19l4rwqc52w7nrpy994b3n2dcv8pjgc530yn2xmgqlqabpxpz3xa'';
  };
    
  packageName = "do-urlencode";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/do-urlencode[.]asd${"$"}' |
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
/* (SYSTEM do-urlencode DESCRIPTION Percent Encoding (aka URL Encoding) library SHA256 19l4rwqc52w7nrpy994b3n2dcv8pjgc530yn2xmgqlqabpxpz3xa URL
    http://beta.quicklisp.org/archive/do-urlencode/2013-07-20/do-urlencode-20130720-git.tgz MD5 c8085e138711c225042acf83b4bf0507 NAME do-urlencode TESTNAME NIL
    FILENAME do-urlencode DEPS ((NAME babel FILENAME babel) (NAME babel-streams FILENAME babel-streams)) DEPENDENCIES (babel babel-streams) VERSION
    20130720-git SIBLINGS NIL) */
