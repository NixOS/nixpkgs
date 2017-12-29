args @ { fetchurl, ... }:
rec {
  baseName = ''misc-extensions'';
  version = ''20150608-git'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/misc-extensions/2015-06-08/misc-extensions-20150608-git.tgz'';
    sha256 = ''0pkvi1l5djwpvm0p8m0bcdjm61gxvzy0vgn415gngdixvbbchdqj'';
  };
    
  packageName = "misc-extensions";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/misc-extensions[.]asd${"$"}' |
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
/* (SYSTEM misc-extensions DESCRIPTION NIL SHA256 0pkvi1l5djwpvm0p8m0bcdjm61gxvzy0vgn415gngdixvbbchdqj URL
    http://beta.quicklisp.org/archive/misc-extensions/2015-06-08/misc-extensions-20150608-git.tgz MD5 ef8a05dd4382bb9d1e3960aeb77e332e NAME misc-extensions
    TESTNAME NIL FILENAME misc-extensions DEPS NIL DEPENDENCIES NIL VERSION 20150608-git SIBLINGS NIL) */
