args @ { fetchurl, ... }:
rec {
  baseName = ''cxml-klacks'';
  version = ''cxml-20110619-git'';

  description = '''';

  deps = [ args."cxml-xml" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cxml/2011-06-19/cxml-20110619-git.tgz'';
    sha256 = ''04k6syn9p7qsazi84kab9n9ki2pb5hrcs0ilw7wikxfqnbabm2yk'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :cxml)"' "$out/bin/cxml-klacks-lisp-launcher.sh" ""
    '';
  };
}
