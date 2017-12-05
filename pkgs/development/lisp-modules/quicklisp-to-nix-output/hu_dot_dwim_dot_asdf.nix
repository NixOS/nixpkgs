args @ { fetchurl, ... }:
rec {
  baseName = ''hu_dot_dwim_dot_asdf'';
  version = ''20170630-darcs'';

  description = ''Various ASDF extensions such as attached test and documentation system, explicit development support, etc.'';

  deps = [ args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/hu.dwim.asdf/2017-06-30/hu.dwim.asdf-20170630-darcs.tgz'';
    sha256 = ''151l4s0cd6jxhz1q635zhyq48b1sz9ns88agj92r0f2q8igdx0fb'';
  };
    
  packageName = "hu.dwim.asdf";

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
    151l4s0cd6jxhz1q635zhyq48b1sz9ns88agj92r0f2q8igdx0fb URL http://beta.quicklisp.org/archive/hu.dwim.asdf/2017-06-30/hu.dwim.asdf-20170630-darcs.tgz MD5
    b086cb36b6a88641497b20c39937c9d4 NAME hu.dwim.asdf TESTNAME NIL FILENAME hu_dot_dwim_dot_asdf DEPS ((NAME uiop FILENAME uiop)) DEPENDENCIES (uiop) VERSION
    20170630-darcs SIBLINGS (hu.dwim.asdf.documentation)) */
