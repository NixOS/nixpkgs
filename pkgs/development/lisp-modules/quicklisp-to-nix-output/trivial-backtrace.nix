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
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/trivial-backtrace[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM trivial-backtrace DESCRIPTION trivial-backtrace SHA256 1vcvalcv2ljiv2gyh8xjcg62cjsripjwmnhc8zji35ja1xyqvxhx URL
    http://beta.quicklisp.org/archive/trivial-backtrace/2016-05-31/trivial-backtrace-20160531-git.tgz MD5 a3b41b4ae24e3fde303a2623201aac4d NAME
    trivial-backtrace TESTNAME NIL FILENAME trivial-backtrace DEPS NIL DEPENDENCIES NIL VERSION 20160531-git SIBLINGS (trivial-backtrace-test)) */
