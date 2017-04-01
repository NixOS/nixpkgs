args @ { fetchurl, ... }:
rec {
  baseName = ''alexandria'';
  version = ''20170227-git'';

  description = ''Alexandria is a collection of portable public domain utilities.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/alexandria/2017-02-27/alexandria-20170227-git.tgz'';
    sha256 = ''0gnn4ysyvqf8wfi94kh6x23iwx3czaicam1lz9pnwsv40ws5fwwh'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/alexandria[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM alexandria DESCRIPTION Alexandria is a collection of portable public domain utilities. SHA256 0gnn4ysyvqf8wfi94kh6x23iwx3czaicam1lz9pnwsv40ws5fwwh
    URL http://beta.quicklisp.org/archive/alexandria/2017-02-27/alexandria-20170227-git.tgz MD5 b0cbf86723fa3a1fe5c544e8079a3be3 NAME alexandria TESTNAME NIL
    FILENAME alexandria DEPS NIL DEPENDENCIES NIL VERSION 20170227-git SIBLINGS (alexandria-tests)) */
