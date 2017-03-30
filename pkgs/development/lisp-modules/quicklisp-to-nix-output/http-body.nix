args @ { fetchurl, ... }:
rec {
  baseName = ''http-body'';
  version = ''20161204-git'';

  description = ''HTTP POST data parser for Common Lisp'';

  deps = [ args."babel" args."cl-ppcre" args."cl-utilities" args."fast-http" args."flexi-streams" args."jonathan" args."quri" args."trivial-gray-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/http-body/2016-12-04/http-body-20161204-git.tgz'';
    sha256 = ''1y50yipsbl4j99igmfi83pr7p56hb31dcplpy05fp5alkb5rv0gi'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :http-body)"' "$out/bin/http-body-lisp-launcher.sh" ""
    '';
  };
}
