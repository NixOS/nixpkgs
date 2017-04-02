args @ { fetchurl, ... }:
rec {
  baseName = ''cl-unicode'';
  version = ''0.1.5'';

  description = ''Portable Unicode Library'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-unicode/2014-12-17/cl-unicode-0.1.5.tgz'';
    sha256 = ''1jd5qq5ji6l749c4x415z22y9r0k9z18pdi9p9fqvamzh854i46n'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-unicode[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM cl-unicode DESCRIPTION Portable Unicode Library SHA256 1jd5qq5ji6l749c4x415z22y9r0k9z18pdi9p9fqvamzh854i46n URL
    http://beta.quicklisp.org/archive/cl-unicode/2014-12-17/cl-unicode-0.1.5.tgz MD5 2fd456537bd670126da84466226bc5c5 NAME cl-unicode TESTNAME NIL FILENAME
    cl-unicode DEPS NIL DEPENDENCIES NIL VERSION 0.1.5 SIBLINGS NIL) */
