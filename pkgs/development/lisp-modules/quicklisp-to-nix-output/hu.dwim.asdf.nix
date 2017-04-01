args @ { fetchurl, ... }:
rec {
  baseName = ''hu.dwim.asdf'';
  version = ''20151218-darcs'';

  description = ''Various ASDF extensions such as attached test and documentation system, explicit development support, etc.'';

  deps = [ args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/hu.dwim.asdf/2015-12-18/hu.dwim.asdf-20151218-darcs.tgz'';
    sha256 = ''18qdysv7zd2avdl8lc3gbnif8crjn0qs45fmnw8hia4dmd71k0k4'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/hu.dwim.asdf[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM hu.dwim.asdf DESCRIPTION Various ASDF extensions such as attached test and documentation system, explicit development support, etc. SHA256
    18qdysv7zd2avdl8lc3gbnif8crjn0qs45fmnw8hia4dmd71k0k4 URL http://beta.quicklisp.org/archive/hu.dwim.asdf/2015-12-18/hu.dwim.asdf-20151218-darcs.tgz MD5
    68ada32eb844abd8e2e6bc029126fa5f NAME hu.dwim.asdf TESTNAME NIL FILENAME hu.dwim.asdf DEPS ((NAME uiop)) DEPENDENCIES (uiop) VERSION 20151218-darcs
    SIBLINGS (hu.dwim.asdf.documentation)) */
