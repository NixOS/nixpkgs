args @ { fetchurl, ... }:
rec {
  baseName = ''smart-buffer'';
  version = ''20160628-git'';

  description = ''Smart octets buffer'';

  deps = [ args."flexi-streams" args."uiop" args."xsubseq" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/smart-buffer/2016-06-28/smart-buffer-20160628-git.tgz'';
    sha256 = ''1wp50snkc8739n91xlnfnq1dzz3kfp0awgp92m7xbpcw3hbaib1s'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :smart-buffer)"' "$out/bin/smart-buffer-lisp-launcher.sh" ""
    '';
  };
}
