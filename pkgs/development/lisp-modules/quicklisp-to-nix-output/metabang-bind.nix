args @ { fetchurl, ... }:
rec {
  baseName = ''metabang-bind'';
  version = ''20170124-git'';

  description = ''Bind is a macro that generalizes multiple-value-bind, let, let*, destructuring-bind, structure and slot accessors, and a whole lot more.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/metabang-bind/2017-01-24/metabang-bind-20170124-git.tgz'';
    sha256 = ''1xyiyrc9c02ylg6b749h2ihn6922kb179x7k338dmglf4mpyqxwc'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :metabang-bind)"' "$out/bin/metabang-bind-lisp-launcher.sh" ""
    '';
  };
}
