args @ { fetchurl, ... }:
rec {
  baseName = ''myway'';
  version = ''20150302-git'';

  description = ''Sinatra-compatible routing library.'';

  deps = [ args."alexandria" args."cl-ppcre" args."cl-utilities" args."map-set" args."quri" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/myway/2015-03-02/myway-20150302-git.tgz'';
    sha256 = ''1spab9zzhwjg3r5xncr5ncha7phw72wp49cxxncgphh1lfaiyblh'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :myway)"' "$out/bin/myway-lisp-launcher.sh" ""
    '';
  };
}
