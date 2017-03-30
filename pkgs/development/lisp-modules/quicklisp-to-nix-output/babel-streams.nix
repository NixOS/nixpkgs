args @ { fetchurl, ... }:
rec {
  baseName = ''babel-streams'';
  version = ''babel-20150608-git'';

  description = ''Some useful streams based on Babel's encoding code'';

  deps = [ args."alexandria" args."babel" args."trivial-gray-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/babel/2015-06-08/babel-20150608-git.tgz'';
    sha256 = ''0nv2w7k33rwc4dwi33ay2rkmvnj4vsz9ar27z8fiar34895vndk5'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :babel-streams)"' "$out/bin/babel-streams-lisp-launcher.sh" ""
    '';
  };
}
