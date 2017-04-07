args @ { fetchurl, ... }:
rec {
  baseName = ''hu.dwim.asdf'';
  version = ''20170403-darcs'';

  description = ''Various ASDF extensions such as attached test and documentation system, explicit development support, etc.'';

  deps = [ args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/hu.dwim.asdf/2017-04-03/hu.dwim.asdf-20170403-darcs.tgz'';
    sha256 = ''0avhfdg2ypv0cnwzihq64zwd562c4ls4bx6014mwgdfggp4b00ll'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/hu.dwim.asdf[.]asd${"$"}' |
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
/* (SYSTEM hu.dwim.asdf DESCRIPTION Various ASDF extensions such as attached test and documentation system, explicit development support, etc. SHA256
    0avhfdg2ypv0cnwzihq64zwd562c4ls4bx6014mwgdfggp4b00ll URL http://beta.quicklisp.org/archive/hu.dwim.asdf/2017-04-03/hu.dwim.asdf-20170403-darcs.tgz MD5
    53cbeb56a8ee066116069d80c7fc3f65 NAME hu.dwim.asdf TESTNAME NIL FILENAME hu.dwim.asdf DEPS ((NAME uiop)) DEPENDENCIES (uiop) VERSION 20170403-darcs
    SIBLINGS (hu.dwim.asdf.documentation)) */
