args @ { fetchurl, ... }:
rec {
  baseName = ''split-sequence'';
  version = ''1.2'';

  description = ''Splits a sequence into a list of subsequences
  delimited by objects satisfying a test.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/split-sequence/2015-08-04/split-sequence-1.2.tgz'';
    sha256 = ''12x5yfvinqz9jzxwlsg226103a9sdf67zpzn5izggvdlw0v5qp0l'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :split-sequence)"' "$out/bin/split-sequence-lisp-launcher.sh" ""
    '';
  };
}
