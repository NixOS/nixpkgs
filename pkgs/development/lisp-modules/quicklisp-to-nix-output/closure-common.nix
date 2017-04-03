args @ { fetchurl, ... }:
rec {
  baseName = ''closure-common'';
  version = ''20101107-git'';

  description = '''';

  deps = [ args."babel" args."trivial-gray-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/closure-common/2010-11-07/closure-common-20101107-git.tgz'';
    sha256 = ''1982dpn2z7rlznn74gxy9biqybh2d4r1n688h9pn1s2bssgv3hk4'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/closure-common[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM closure-common DESCRIPTION NIL SHA256 1982dpn2z7rlznn74gxy9biqybh2d4r1n688h9pn1s2bssgv3hk4 URL
    http://beta.quicklisp.org/archive/closure-common/2010-11-07/closure-common-20101107-git.tgz MD5 12c45a2f0420b2e86fa06cb6575b150a NAME closure-common
    TESTNAME NIL FILENAME closure-common DEPS ((NAME babel) (NAME trivial-gray-streams)) DEPENDENCIES (babel trivial-gray-streams) VERSION 20101107-git
    SIBLINGS NIL) */
