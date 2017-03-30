args @ { fetchurl, ... }:
rec {
  baseName = ''alexandria'';
  version = ''20170227-git'';

  description = ''Alexandria is a collection of portable public domain utilities.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/alexandria/2017-02-27/alexandria-20170227-git.tgz'';
    sha256 = ''0gnn4ysyvqf8wfi94kh6x23iwx3czaicam1lz9pnwsv40ws5fwwh'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :alexandria)"' "$out/bin/alexandria-lisp-launcher.sh" ""
    '';
  };
}
