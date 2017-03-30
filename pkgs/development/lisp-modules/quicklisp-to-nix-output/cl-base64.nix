args @ { fetchurl, ... }:
rec {
  baseName = ''cl-base64'';
  version = ''20150923-git'';

  description = ''Base64 encoding and decoding with URI support.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-base64/2015-09-23/cl-base64-20150923-git.tgz'';
    sha256 = ''0haip5x0091r9xa8gdzr21s0rk432998nbxxfys35lhnyc1vgyhp'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :cl-base64)"' "$out/bin/cl-base64-lisp-launcher.sh" ""
    '';
  };
}
