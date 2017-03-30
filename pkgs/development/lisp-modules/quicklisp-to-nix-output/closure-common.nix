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
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :closure-common)"' "$out/bin/closure-common-lisp-launcher.sh" ""
    '';
  };
}
