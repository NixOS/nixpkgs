args @ { fetchurl, ... }:
rec {
  baseName = ''local-time'';
  version = ''20170516-git'';

  description = ''A library for manipulating dates and times, based on a paper by Erik Naggum'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/local-time/2017-05-16/local-time-20170516-git.tgz'';
    sha256 = ''0qqy13pc3mqy4vkrvyfvg66n80kzxga5iax2ps0150ir61hwz35p'';
  };
    
  packageName = "local-time";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/local-time[.]asd${"$"}' |
        while read f; do
          env -i \
          NIX_LISP="$NIX_LISP" \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(progn
            (asdf:load-system :$(basename "$f" .asd))
            (asdf:perform (quote asdf:compile-bundle-op) :$(basename "$f" .asd))
            (ignore-errors (asdf:perform (quote asdf:deliver-asd-op) :$(basename "$f" .asd)))
            )'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM local-time DESCRIPTION A library for manipulating dates and times, based on a paper by Erik Naggum SHA256
    0qqy13pc3mqy4vkrvyfvg66n80kzxga5iax2ps0150ir61hwz35p URL http://beta.quicklisp.org/archive/local-time/2017-05-16/local-time-20170516-git.tgz MD5
    b2f5b94458f34f4b73cdd614e1304a9a NAME local-time TESTNAME NIL FILENAME local-time DEPS NIL DEPENDENCIES NIL VERSION 20170516-git SIBLINGS
    (cl-postgres+local-time local-time.test)) */
