args @ { fetchurl, ... }:
rec {
  baseName = ''quri'';
  version = ''20161204-git'';

  description = ''Yet another URI library for Common Lisp'';

  deps = [ args."alexandria" args."babel" args."cl-utilities" args."split-sequence" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/quri/2016-12-04/quri-20161204-git.tgz'';
    sha256 = ''14if83kd2mv68p4g4ch2w796w3micpzv40z7xrcwzwj64wngwabv'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :quri)"' "$out/bin/quri-lisp-launcher.sh" ""
    '';
  };
}
