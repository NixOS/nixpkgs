args @ { fetchurl, ... }:
rec {
  baseName = ''uffi'';
  version = ''20170630-git'';

  description = ''Universal Foreign Function Library for Common Lisp'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/uffi/2017-06-30/uffi-20170630-git.tgz'';
    sha256 = ''1y8f4pw1sw9d7zgaj1lfi87fjws934qc3gl3fan9py967cl5i7jf'';
  };
    
  packageName = "uffi";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/uffi[.]asd${"$"}' |
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
/* (SYSTEM uffi DESCRIPTION Universal Foreign Function Library for Common Lisp SHA256 1y8f4pw1sw9d7zgaj1lfi87fjws934qc3gl3fan9py967cl5i7jf URL
    http://beta.quicklisp.org/archive/uffi/2017-06-30/uffi-20170630-git.tgz MD5 8ac448122b79a41ec2b0647f06af7c12 NAME uffi TESTNAME NIL FILENAME uffi DEPS NIL
    DEPENDENCIES NIL VERSION 20170630-git SIBLINGS (uffi-tests)) */
