args @ { fetchurl, ... }:
rec {
  baseName = ''let-plus'';
  version = ''20170124-git'';

  description = ''Destructuring extension of LET*.'';

  deps = [ args."alexandria" args."anaphora" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/let-plus/2017-01-24/let-plus-20170124-git.tgz'';
    sha256 = ''1hfsw4g36vccz2lx6gk375arjj6y85yh9ch3pq7yiybjlxx68xi8'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/let-plus[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM let-plus DESCRIPTION Destructuring extension of LET*. SHA256 1hfsw4g36vccz2lx6gk375arjj6y85yh9ch3pq7yiybjlxx68xi8 URL
    http://beta.quicklisp.org/archive/let-plus/2017-01-24/let-plus-20170124-git.tgz MD5 1180608e4da53f3866a99d4cca72e3b1 NAME let-plus TESTNAME NIL FILENAME
    let-plus DEPS ((NAME alexandria) (NAME anaphora)) DEPENDENCIES (alexandria anaphora) VERSION 20170124-git SIBLINGS NIL) */
