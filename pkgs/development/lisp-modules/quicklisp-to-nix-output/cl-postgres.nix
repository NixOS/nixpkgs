args @ { fetchurl, ... }:
rec {
  baseName = ''cl-postgres'';
  version = ''postmodern-20170124-git'';

  description = ''Low-level client library for PostgreSQL'';

  deps = [ args."md5" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/postmodern/2017-01-24/postmodern-20170124-git.tgz'';
    sha256 = ''1hdgdpkba225xqvpsr7r1j78cx0ha23x6f69ab2666plpyw321k8'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-postgres[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM cl-postgres DESCRIPTION Low-level client library for PostgreSQL SHA256 1hdgdpkba225xqvpsr7r1j78cx0ha23x6f69ab2666plpyw321k8 URL
    http://beta.quicklisp.org/archive/postmodern/2017-01-24/postmodern-20170124-git.tgz MD5 d19b368a8883093f20a47be83709b0c5 NAME cl-postgres TESTNAME NIL
    FILENAME cl-postgres DEPS ((NAME md5)) DEPENDENCIES (md5) VERSION postmodern-20170124-git SIBLINGS (postmodern s-sql simple-date)) */
