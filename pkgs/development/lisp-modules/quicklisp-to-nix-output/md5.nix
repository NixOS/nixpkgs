args @ { fetchurl, ... }:
rec {
  baseName = ''md5'';
  version = ''20150804-git'';

  description = ''The MD5 Message-Digest Algorithm RFC 1321'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/md5/2015-08-04/md5-20150804-git.tgz'';
    sha256 = ''1sf79pjip19sx7zmznz1wm4563qc208lq49m0jnhxbv09wmm4vc5'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/md5[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM md5 DESCRIPTION The MD5 Message-Digest Algorithm RFC 1321 SHA256 1sf79pjip19sx7zmznz1wm4563qc208lq49m0jnhxbv09wmm4vc5 URL
    http://beta.quicklisp.org/archive/md5/2015-08-04/md5-20150804-git.tgz MD5 69331e0d326cbc3286ac447e2868e7fd NAME md5 TESTNAME NIL FILENAME md5 DEPS NIL
    DEPENDENCIES NIL VERSION 20150804-git SIBLINGS NIL) */
