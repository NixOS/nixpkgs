args @ { fetchurl, ... }:
rec {
  baseName = ''myway'';
  version = ''20150302-git'';

  description = ''Sinatra-compatible routing library.'';

  deps = [ args."quri" args."map-set" args."cl-utilities" args."cl-ppcre" args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/myway/2015-03-02/myway-20150302-git.tgz'';
    sha256 = ''1spab9zzhwjg3r5xncr5ncha7phw72wp49cxxncgphh1lfaiyblh'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/myway[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM myway DESCRIPTION Sinatra-compatible routing library. SHA256 1spab9zzhwjg3r5xncr5ncha7phw72wp49cxxncgphh1lfaiyblh URL
    http://beta.quicklisp.org/archive/myway/2015-03-02/myway-20150302-git.tgz MD5 6a16b41eb3216c469bfc8783cce08b01 NAME myway TESTNAME NIL FILENAME myway DEPS
    ((NAME quri) (NAME map-set) (NAME cl-utilities) (NAME cl-ppcre) (NAME alexandria)) DEPENDENCIES (quri map-set cl-utilities cl-ppcre alexandria) VERSION
    20150302-git SIBLINGS (myway-test)) */
