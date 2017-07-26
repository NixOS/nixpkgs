args @ { fetchurl, ... }:
rec {
  baseName = ''cl-ansi-text'';
  version = ''20150804-git'';

  description = ''ANSI control string characters, focused on color'';

  deps = [ args."cl-colors" args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-ansi-text/2015-08-04/cl-ansi-text-20150804-git.tgz'';
    sha256 = ''112w7qg8yp28qyc2b5c7km457krr3xksxyps1icmgdpqf9ccpn2i'';
  };
    
  packageName = "cl-ansi-text";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-ansi-text[.]asd${"$"}' |
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
/* (SYSTEM cl-ansi-text DESCRIPTION ANSI control string characters, focused on color SHA256 112w7qg8yp28qyc2b5c7km457krr3xksxyps1icmgdpqf9ccpn2i URL
    http://beta.quicklisp.org/archive/cl-ansi-text/2015-08-04/cl-ansi-text-20150804-git.tgz MD5 70aa38b40377a5e89a7f22bb68b3f796 NAME cl-ansi-text TESTNAME NIL
    FILENAME cl-ansi-text DEPS ((NAME cl-colors FILENAME cl-colors) (NAME alexandria FILENAME alexandria)) DEPENDENCIES (cl-colors alexandria) VERSION
    20150804-git SIBLINGS (cl-ansi-text-test)) */
