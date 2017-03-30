args @ { fetchurl, ... }:
rec {
  baseName = ''cl-l10n'';
  version = ''20161204-darcs'';

  description = ''Portable CL Locale Support'';

  deps = [ args."alexandria" args."cl-fad" args."cl-l10n-cldr" args."cl-ppcre" args."closer-mop" args."cxml" args."flexi-streams" args."iterate" args."local-time" args."metabang-bind" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-l10n/2016-12-04/cl-l10n-20161204-darcs.tgz'';
    sha256 = ''1r8jgwks21az78c5kdxgw5llk9ml423vjkv1f93qg1vx3zma6vzl'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :cl-l10n)"' "$out/bin/cl-l10n-lisp-launcher.sh" ""
    '';
  };
}
