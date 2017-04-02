args @ { fetchurl, ... }:
rec {
  baseName = ''esrap'';
  version = ''20170124-git'';

  description = ''A Packrat / Parsing Grammar / TDPL parser for Common Lisp.'';

  deps = [ args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/esrap/2017-01-24/esrap-20170124-git.tgz'';
    sha256 = ''1182011bbhvkw2qsdqrccl879vf5k7bcda318n0xskk35hzircp8'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/esrap[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM esrap DESCRIPTION A Packrat / Parsing Grammar / TDPL parser for Common Lisp. SHA256 1182011bbhvkw2qsdqrccl879vf5k7bcda318n0xskk35hzircp8 URL
    http://beta.quicklisp.org/archive/esrap/2017-01-24/esrap-20170124-git.tgz MD5 72f7a7d8e5808586dfd3ab1698e3d11f NAME esrap TESTNAME NIL FILENAME esrap DEPS
    ((NAME alexandria)) DEPENDENCIES (alexandria) VERSION 20170124-git SIBLINGS NIL) */
