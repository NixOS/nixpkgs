args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-backtrace'';
  version = ''20160531-git'';

  description = ''trivial-backtrace'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-backtrace/2016-05-31/trivial-backtrace-20160531-git.tgz'';
    sha256 = ''1vcvalcv2ljiv2gyh8xjcg62cjsripjwmnhc8zji35ja1xyqvxhx'';
  };

  overrides = x: {
    postInstall = ''
        echo "$CL_SOURCE_REGISTRY"
        NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(asdf:load-system :trivial-backtrace)"' "$out/bin/trivial-backtrace-lisp-launcher.sh" ""
    '';
  };
}
