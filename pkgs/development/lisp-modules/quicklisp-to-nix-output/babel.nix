args @ { fetchurl, ... }:
rec {
  baseName = ''babel'';
  version = ''20150608-git'';

  description = ''Babel, a charset conversion library.'';

  deps = [ args."trivial-features" args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/babel/2015-06-08/babel-20150608-git.tgz'';
    sha256 = ''0nv2w7k33rwc4dwi33ay2rkmvnj4vsz9ar27z8fiar34895vndk5'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/babel[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM babel DESCRIPTION Babel, a charset conversion library. SHA256 0nv2w7k33rwc4dwi33ay2rkmvnj4vsz9ar27z8fiar34895vndk5 URL
    http://beta.quicklisp.org/archive/babel/2015-06-08/babel-20150608-git.tgz MD5 308e6c9132994cf09db7766569ee23fd NAME babel TESTNAME NIL FILENAME babel DEPS
    ((NAME trivial-features) (NAME alexandria)) DEPENDENCIES (trivial-features alexandria) VERSION 20150608-git SIBLINGS (babel-streams babel-tests)) */
