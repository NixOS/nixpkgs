args @ { fetchurl, ... }:
rec {
  baseName = ''zpb-ttf'';
  version = ''1.0.3'';

  description = ''Access TrueType font metrics and outlines from Common Lisp'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/zpb-ttf/2013-07-20/zpb-ttf-1.0.3.tgz'';
    sha256 = ''1irv0d0pcbwi2wx6hhjjyxzw12lnw8pvyg6ljsljh8xmhppbg5j6'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :zpb-ttf)"' "$out/bin/zpb-ttf-lisp-launcher.sh" ""
    '';
  };
}
