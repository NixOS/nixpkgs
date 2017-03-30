args @ { fetchurl, ... }:
rec {
  baseName = ''jonathan'';
  version = ''20170124-git'';

  description = ''High performance JSON encoder and decoder. Currently support: SBCL, CCL.'';

  deps = [ args."babel" args."cl-annot" args."cl-ppcre" args."cl-syntax" args."cl-syntax-annot" args."fast-io" args."proc-parse" args."trivial-types" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/jonathan/2017-01-24/jonathan-20170124-git.tgz'';
    sha256 = ''1r54w7i1fxaqz6q7idamcy3bvsg0pvfjcs2qq4dag519zwcpln5l'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :jonathan)"' "$out/bin/jonathan-lisp-launcher.sh" ""
    '';
  };
}
