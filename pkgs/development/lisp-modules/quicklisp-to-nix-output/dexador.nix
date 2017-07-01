args @ { fetchurl, ... }:
rec {
  baseName = ''dexador'';
  version = ''20170516-git'';

  description = ''Yet another HTTP client for Common Lisp'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/dexador/2017-05-16/dexador-20170516-git.tgz'';
    sha256 = ''129ar4z972wl3prhzsfy0mb4r41b0j179zs3mglq6gl7awafq8r6'';
  };
    
  packageName = "dexador";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/dexador[.]asd${"$"}' |
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
/* (SYSTEM dexador DESCRIPTION Yet another HTTP client for Common Lisp SHA256 129ar4z972wl3prhzsfy0mb4r41b0j179zs3mglq6gl7awafq8r6 URL
    http://beta.quicklisp.org/archive/dexador/2017-05-16/dexador-20170516-git.tgz MD5 463972f0b98fd2a641ce2bfab4400dc7 NAME dexador TESTNAME NIL FILENAME
    dexador DEPS NIL DEPENDENCIES NIL VERSION 20170516-git SIBLINGS (dexador-test)) */
