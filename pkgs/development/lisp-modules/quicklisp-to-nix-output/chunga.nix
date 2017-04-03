args @ { fetchurl, ... }:
rec {
  baseName = ''chunga'';
  version = ''1.1.6'';

  description = '''';

  deps = [ args."trivial-gray-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/chunga/2014-12-17/chunga-1.1.6.tgz'';
    sha256 = ''1ivdfi9hjkzp2anhpjm58gzrjpn6mdsp35km115c1j1c4yhs9lzg'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/chunga[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM chunga DESCRIPTION NIL SHA256 1ivdfi9hjkzp2anhpjm58gzrjpn6mdsp35km115c1j1c4yhs9lzg URL
    http://beta.quicklisp.org/archive/chunga/2014-12-17/chunga-1.1.6.tgz MD5 75f5c4f9dec3a8a181ed5ef7e5d700b5 NAME chunga TESTNAME NIL FILENAME chunga DEPS
    ((NAME trivial-gray-streams)) DEPENDENCIES (trivial-gray-streams) VERSION 1.1.6 SIBLINGS NIL) */
