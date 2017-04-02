args @ { fetchurl, ... }:
rec {
  baseName = ''3bmd-ext-wiki-links'';
  version = ''3bmd-20161204-git'';

  description = ''example extension to 3bmd implementing simple wiki-style [[links]]'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/3bmd/2016-12-04/3bmd-20161204-git.tgz'';
    sha256 = ''158rymq6ra9ipmkqrqmgr4ay5m46cdxxha03622svllhyf7xzypx'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/3bmd-ext-wiki-links[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM 3bmd-ext-wiki-links DESCRIPTION example extension to 3bmd implementing simple wiki-style [[links]] SHA256
    158rymq6ra9ipmkqrqmgr4ay5m46cdxxha03622svllhyf7xzypx URL http://beta.quicklisp.org/archive/3bmd/2016-12-04/3bmd-20161204-git.tgz MD5
    b80864c74437e0cfb66663e9bbf08fed NAME 3bmd-ext-wiki-links TESTNAME NIL FILENAME 3bmd-ext-wiki-links DEPS NIL DEPENDENCIES NIL VERSION 3bmd-20161204-git
    SIBLINGS (3bmd-ext-code-blocks 3bmd-ext-definition-lists 3bmd-ext-tables 3bmd-youtube-tests 3bmd-youtube 3bmd)) */
