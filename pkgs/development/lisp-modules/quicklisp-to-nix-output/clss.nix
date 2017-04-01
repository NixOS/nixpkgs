args @ { fetchurl, ... }:
rec {
  baseName = ''clss'';
  version = ''20170124-git'';

  description = ''A DOM tree searching engine based on CSS selectors.'';

  deps = [ args."array-utils" args."plump" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clss/2017-01-24/clss-20170124-git.tgz'';
    sha256 = ''0rrg3brzash1b14n686xjx6d5glm2vg32g0i8hyvaffqd82493pb'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/clss[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM clss DESCRIPTION A DOM tree searching engine based on CSS selectors. SHA256 0rrg3brzash1b14n686xjx6d5glm2vg32g0i8hyvaffqd82493pb URL
    http://beta.quicklisp.org/archive/clss/2017-01-24/clss-20170124-git.tgz MD5 f05606cab3a75e01c57fd264d1c71863 NAME clss TESTNAME NIL FILENAME clss DEPS
    ((NAME array-utils) (NAME plump)) DEPENDENCIES (array-utils plump) VERSION 20170124-git SIBLINGS NIL) */
