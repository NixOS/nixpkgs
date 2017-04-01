args @ { fetchurl, ... }:
rec {
  baseName = ''ironclad'';
  version = ''ironclad_0.33.0'';

  description = ''A cryptographic toolkit written in pure Common Lisp'';

  deps = [ args."nibbles" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/ironclad/2014-11-06/ironclad_0.33.0.tgz'';
    sha256 = ''1ld0xz8gmi566zxl1cva5yi86aw1wb6i6446gxxdw1lisxx3xwz7'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/ironclad[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM ironclad DESCRIPTION A cryptographic toolkit written in pure Common Lisp SHA256 1ld0xz8gmi566zxl1cva5yi86aw1wb6i6446gxxdw1lisxx3xwz7 URL
    http://beta.quicklisp.org/archive/ironclad/2014-11-06/ironclad_0.33.0.tgz MD5 2b7befe607e2fedffbdd45b2443db718 NAME ironclad TESTNAME NIL FILENAME ironclad
    DEPS ((NAME nibbles)) DEPENDENCIES (nibbles) VERSION ironclad_0.33.0 SIBLINGS (ironclad-text)) */
