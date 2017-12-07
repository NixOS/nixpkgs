args @ { fetchurl, ... }:
rec {
  baseName = ''dynamic-classes'';
  version = ''20130128-git'';

  description = '''';

  deps = [ args."metatilities-base" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/dynamic-classes/2013-01-28/dynamic-classes-20130128-git.tgz'';
    sha256 = ''0i2b9k8f8jgn86kz503z267w0zv4gdqajzw755xwhqfaknix74sa'';
  };
    
  packageName = "dynamic-classes";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/dynamic-classes[.]asd${"$"}' |
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
/* (SYSTEM dynamic-classes DESCRIPTION NIL SHA256 0i2b9k8f8jgn86kz503z267w0zv4gdqajzw755xwhqfaknix74sa URL
    http://beta.quicklisp.org/archive/dynamic-classes/2013-01-28/dynamic-classes-20130128-git.tgz MD5 a6ed01c4f21df2b6a142328b24ac7ba3 NAME dynamic-classes
    TESTNAME NIL FILENAME dynamic-classes DEPS ((NAME metatilities-base FILENAME metatilities-base)) DEPENDENCIES (metatilities-base) VERSION 20130128-git
    SIBLINGS (dynamic-classes-test)) */
