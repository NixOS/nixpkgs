args @ { fetchurl, ... }:
rec {
  baseName = ''local-time'';
  version = ''20170124-git'';

  description = ''A library for manipulating dates and times, based on a paper by Erik Naggum'';

  deps = [ args."cl-fad" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/local-time/2017-01-24/local-time-20170124-git.tgz'';
    sha256 = ''0nf21bhclr2cwpflf733wn6hr6mcz94dr796jk91f0ck28nf7ab1'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :local-time)"' "$out/bin/local-time-lisp-launcher.sh" ""
    '';
  };
}
