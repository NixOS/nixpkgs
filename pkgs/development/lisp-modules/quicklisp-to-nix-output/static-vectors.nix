args @ { fetchurl, ... }:
rec {
  baseName = ''static-vectors'';
  version = ''v1.8.2'';

  description = ''Create vectors allocated in static memory.'';

  deps = [ args."alexandria" args."cffi" args."cffi-grovel" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/static-vectors/2017-01-24/static-vectors-v1.8.2.tgz'';
    sha256 = ''0p35f0wrnv46bmmxlviwpsbxnlnkmxwd3xp858lhf0dy52cyra1g'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :static-vectors)"' "$out/bin/static-vectors-lisp-launcher.sh" ""
    '';
  };
}
