args @ { fetchurl, ... }:
rec {
  baseName = ''pcall'';
  version = ''0.3'';

  description = '''';

  deps = [ args."bordeaux-threads" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/pcall/2010-10-06/pcall-0.3.tgz'';
    sha256 = ''02idx1wnv9770fl2nh179sb8njw801g70b5mf8jqhqm2gwsb731y'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/pcall[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM pcall DESCRIPTION NIL SHA256 02idx1wnv9770fl2nh179sb8njw801g70b5mf8jqhqm2gwsb731y URL
    http://beta.quicklisp.org/archive/pcall/2010-10-06/pcall-0.3.tgz MD5 019d85dfd1d5d0ee8d4ee475411caf6b NAME pcall TESTNAME NIL FILENAME pcall DEPS
    ((NAME bordeaux-threads)) DEPENDENCIES (bordeaux-threads) VERSION 0.3 SIBLINGS (pcall-queue)) */
