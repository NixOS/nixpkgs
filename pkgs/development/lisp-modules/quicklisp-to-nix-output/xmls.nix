args @ { fetchurl, ... }:
rec {
  baseName = ''xmls'';
  version = ''1.7'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/xmls/2015-04-07/xmls-1.7.tgz'';
    sha256 = ''1pch221g5jv02rb21ly9ik4cmbzv8ca6bnyrs4s0yfrrq0ji406b'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :xmls)"' "$out/bin/xmls-lisp-launcher.sh" ""
    '';
  };
}
