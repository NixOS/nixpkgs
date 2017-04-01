args @ { fetchurl, ... }:
rec {
  baseName = ''fast-io'';
  version = ''20170124-git'';

  description = ''Alternative I/O mechanism to a stream or vector'';

  deps = [ args."trivial-gray-streams" args."static-vectors" args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/fast-io/2017-01-24/fast-io-20170124-git.tgz'';
    sha256 = ''0w57iddbpdcchnv3zg7agd3ydm36aw2mni4iasi8wd628gq9a6i2'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/fast-io[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM fast-io DESCRIPTION Alternative I/O mechanism to a stream or vector SHA256 0w57iddbpdcchnv3zg7agd3ydm36aw2mni4iasi8wd628gq9a6i2 URL
    http://beta.quicklisp.org/archive/fast-io/2017-01-24/fast-io-20170124-git.tgz MD5 e9fa77c0e75a9f32e56c27ef6861bce2 NAME fast-io TESTNAME NIL FILENAME
    fast-io DEPS ((NAME trivial-gray-streams) (NAME static-vectors) (NAME alexandria)) DEPENDENCIES (trivial-gray-streams static-vectors alexandria) VERSION
    20170124-git SIBLINGS (fast-io-test)) */
