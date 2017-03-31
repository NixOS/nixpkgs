args @ { fetchurl, ... }:
rec {
  baseName = ''clx-truetype'';
  version = ''20160825-git'';

  description = ''clx-truetype is pure common lisp solution for antialiased TrueType font rendering using CLX and XRender extension.'';

  deps = [ args."cl-aa" args."cl-fad" args."cl-paths-ttf" args."cl-store" args."cl-vectors" args."clx" args."trivial-features" args."zpb-ttf" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clx-truetype/2016-08-25/clx-truetype-20160825-git.tgz'';
    sha256 = ''0ndy067rg9w6636gxwlpnw7f3ck9nrnjb03444pprik9r3c9in67'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :clx-truetype)"' "$out/bin/clx-truetype-lisp-launcher.sh" ""
    '';
  };
}
