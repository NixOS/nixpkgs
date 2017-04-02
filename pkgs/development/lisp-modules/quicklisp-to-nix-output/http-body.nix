args @ { fetchurl, ... }:
rec {
  baseName = ''http-body'';
  version = ''20161204-git'';

  description = ''HTTP POST data parser for Common Lisp'';

  deps = [ args."trivial-gray-streams" args."quri" args."jonathan" args."flexi-streams" args."fast-http" args."cl-utilities" args."cl-ppcre" args."babel" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/http-body/2016-12-04/http-body-20161204-git.tgz'';
    sha256 = ''1y50yipsbl4j99igmfi83pr7p56hb31dcplpy05fp5alkb5rv0gi'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/http-body[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM http-body DESCRIPTION HTTP POST data parser for Common Lisp SHA256 1y50yipsbl4j99igmfi83pr7p56hb31dcplpy05fp5alkb5rv0gi URL
    http://beta.quicklisp.org/archive/http-body/2016-12-04/http-body-20161204-git.tgz MD5 6eda50cf89aa3b6a8e9ccaf324734a0e NAME http-body TESTNAME NIL FILENAME
    http-body DEPS
    ((NAME trivial-gray-streams) (NAME quri) (NAME jonathan) (NAME flexi-streams) (NAME fast-http) (NAME cl-utilities) (NAME cl-ppcre) (NAME babel))
    DEPENDENCIES (trivial-gray-streams quri jonathan flexi-streams fast-http cl-utilities cl-ppcre babel) VERSION 20161204-git SIBLINGS (http-body-test)) */
