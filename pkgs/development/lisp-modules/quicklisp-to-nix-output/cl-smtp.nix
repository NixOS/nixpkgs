args @ { fetchurl, ... }:
rec {
  baseName = ''cl-smtp'';
  version = ''20160825-git'';

  description = ''Common Lisp smtp client.'';

  deps = [ args."cl+ssl" args."cl-base64" args."flexi-streams" args."trivial-gray-streams" args."usocket" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-smtp/2016-08-25/cl-smtp-20160825-git.tgz'';
    sha256 = ''0svkvy6x458a7rgvp3wki0lmhdxpaa1j0brwsw2mlpl2jqkx5dxh'';
  };
    
  packageName = "cl-smtp";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-smtp[.]asd${"$"}' |
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
/* (SYSTEM cl-smtp DESCRIPTION Common Lisp smtp client. SHA256 0svkvy6x458a7rgvp3wki0lmhdxpaa1j0brwsw2mlpl2jqkx5dxh URL
    http://beta.quicklisp.org/archive/cl-smtp/2016-08-25/cl-smtp-20160825-git.tgz MD5 e6bb60e66b0f7d9cc5e4f98aba56998a NAME cl-smtp TESTNAME NIL FILENAME
    cl-smtp DEPS
    ((NAME cl+ssl FILENAME cl+ssl) (NAME cl-base64 FILENAME cl-base64) (NAME flexi-streams FILENAME flexi-streams)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams) (NAME usocket FILENAME usocket))
    DEPENDENCIES (cl+ssl cl-base64 flexi-streams trivial-gray-streams usocket) VERSION 20160825-git SIBLINGS NIL) */
