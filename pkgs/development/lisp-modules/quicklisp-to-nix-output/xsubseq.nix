args @ { fetchurl, ... }:
rec {
  baseName = ''xsubseq'';
  version = ''20150113-git'';

  description = ''Efficient way to manage "subseq"s in Common Lisp'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/xsubseq/2015-01-13/xsubseq-20150113-git.tgz'';
    sha256 = ''0ykjhi7pkqcwm00yzhqvngnx07hsvwbj0c72b08rj4dkngg8is5q'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :xsubseq)"' "$out/bin/xsubseq-lisp-launcher.sh" ""
    '';
  };
}
