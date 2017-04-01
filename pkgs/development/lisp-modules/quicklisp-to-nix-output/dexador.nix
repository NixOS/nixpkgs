args @ { fetchurl, ... }:
rec {
  baseName = ''dexador'';
  version = ''20170227-git'';

  description = ''Yet another HTTP client for Common Lisp'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/dexador/2017-02-27/dexador-20170227-git.tgz'';
    sha256 = ''0fc3hlckxfwz1ymindb9p44c6idfz8z6w5zk8cbd4nvvd0f2a8kz'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/dexador[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM dexador DESCRIPTION Yet another HTTP client for Common Lisp SHA256 0fc3hlckxfwz1ymindb9p44c6idfz8z6w5zk8cbd4nvvd0f2a8kz URL
    http://beta.quicklisp.org/archive/dexador/2017-02-27/dexador-20170227-git.tgz MD5 87895012728d97cf37366c3e4b96fcee NAME dexador TESTNAME NIL FILENAME
    dexador DEPS NIL DEPENDENCIES NIL VERSION 20170227-git SIBLINGS (dexador-test)) */
