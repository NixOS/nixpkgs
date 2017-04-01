args @ { fetchurl, ... }:
rec {
  baseName = ''smart-buffer'';
  version = ''20160628-git'';

  description = ''Smart octets buffer'';

  deps = [ args."xsubseq" args."uiop" args."flexi-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/smart-buffer/2016-06-28/smart-buffer-20160628-git.tgz'';
    sha256 = ''1wp50snkc8739n91xlnfnq1dzz3kfp0awgp92m7xbpcw3hbaib1s'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/smart-buffer[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM smart-buffer DESCRIPTION Smart octets buffer SHA256 1wp50snkc8739n91xlnfnq1dzz3kfp0awgp92m7xbpcw3hbaib1s URL
    http://beta.quicklisp.org/archive/smart-buffer/2016-06-28/smart-buffer-20160628-git.tgz MD5 454d8510618da8111c7ca687549b7035 NAME smart-buffer TESTNAME NIL
    FILENAME smart-buffer DEPS ((NAME xsubseq) (NAME uiop) (NAME flexi-streams)) DEPENDENCIES (xsubseq uiop flexi-streams) VERSION 20160628-git SIBLINGS
    (smart-buffer-test)) */
