args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-utf-8'';
  version = ''20111001-darcs'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-utf-8/2011-10-01/trivial-utf-8-20111001-darcs.tgz'';
    sha256 = ''1lmg185s6w3rzsz3xa41k5w9xw32bi288ifhrxincy8iv92w65wb'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :trivial-utf-8)"' "$out/bin/trivial-utf-8-lisp-launcher.sh" ""
    '';
  };
}
