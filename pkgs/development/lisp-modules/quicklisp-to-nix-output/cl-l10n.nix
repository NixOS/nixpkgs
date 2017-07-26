args @ { fetchurl, ... }:
rec {
  baseName = ''cl-l10n'';
  version = ''20161204-darcs'';

  description = ''Portable CL Locale Support'';

  deps = [ args."alexandria" args."cl-fad" args."cl-l10n-cldr" args."cl-ppcre" args."closer-mop" args."cxml" args."flexi-streams" args."iterate" args."local-time" args."metabang-bind" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-l10n/2016-12-04/cl-l10n-20161204-darcs.tgz'';
    sha256 = ''1r8jgwks21az78c5kdxgw5llk9ml423vjkv1f93qg1vx3zma6vzl'';
  };
    
  packageName = "cl-l10n";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-l10n[.]asd${"$"}' |
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
/* (SYSTEM cl-l10n DESCRIPTION Portable CL Locale Support SHA256 1r8jgwks21az78c5kdxgw5llk9ml423vjkv1f93qg1vx3zma6vzl URL
    http://beta.quicklisp.org/archive/cl-l10n/2016-12-04/cl-l10n-20161204-darcs.tgz MD5 c7cb0bb584b061799abaaaf2bd65c9c5 NAME cl-l10n TESTNAME NIL FILENAME
    cl-l10n DEPS
    ((NAME alexandria FILENAME alexandria) (NAME cl-fad FILENAME cl-fad) (NAME cl-l10n-cldr FILENAME cl-l10n-cldr) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME closer-mop FILENAME closer-mop) (NAME cxml FILENAME cxml) (NAME flexi-streams FILENAME flexi-streams) (NAME iterate FILENAME iterate)
     (NAME local-time FILENAME local-time) (NAME metabang-bind FILENAME metabang-bind))
    DEPENDENCIES (alexandria cl-fad cl-l10n-cldr cl-ppcre closer-mop cxml flexi-streams iterate local-time metabang-bind) VERSION 20161204-darcs SIBLINGS NIL) */
