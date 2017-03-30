args @ { fetchurl, ... }:
rec {
  baseName = ''cl-json'';
  version = ''20141217-git'';

  description = ''JSON in Lisp. JSON (JavaScript Object Notation) is a lightweight data-interchange format.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-json/2014-12-17/cl-json-20141217-git.tgz'';
    sha256 = ''00cfppyi6njsbpv1x03jcv4zwplg0q1138174l3wjkvi3gsql17g'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :cl-json)"' "$out/bin/cl-json-lisp-launcher.sh" ""
    '';
  };
}
