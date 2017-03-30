args @ { fetchurl, ... }:
rec {
  baseName = ''lack-util'';
  version = ''lack-20161204-git'';

  description = '''';

  deps = [ args."ironclad" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/lack/2016-12-04/lack-20161204-git.tgz'';
    sha256 = ''10bnpgbh5nk9lw1xywmvh5661rq91v8sp43ds53x98865ni7flnv'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :lack-util)"' "$out/bin/lack-util-lisp-launcher.sh" ""
    '';
  };
}
