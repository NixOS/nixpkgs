args @ { fetchurl, ... }:
rec {
  baseName = ''babel-streams'';
  version = ''babel-20150608-git'';

  description = ''Some useful streams based on Babel's encoding code'';

  deps = [ args."trivial-gray-streams" args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/babel/2015-06-08/babel-20150608-git.tgz'';
    sha256 = ''0nv2w7k33rwc4dwi33ay2rkmvnj4vsz9ar27z8fiar34895vndk5'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/babel-streams[.]asd${"$"}' |
        while read f; do
          env -i \
          NIX_LISP="$NIX_LISP" \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(progn
            (asdf:load-system :$(basename "$f" .asd))
            (asdf:perform (quote asdf:compile-bundle-op) :$(basename "$f" .asd))
            (ignore-errors (asdf:perform (quote asdf:deliver-asd-op) :$(basename "$f" .asd)))
            )'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM babel-streams DESCRIPTION Some useful streams based on Babel's encoding code SHA256 0nv2w7k33rwc4dwi33ay2rkmvnj4vsz9ar27z8fiar34895vndk5 URL
    http://beta.quicklisp.org/archive/babel/2015-06-08/babel-20150608-git.tgz MD5 308e6c9132994cf09db7766569ee23fd NAME babel-streams TESTNAME NIL FILENAME
    babel-streams DEPS ((NAME trivial-gray-streams) (NAME alexandria)) DEPENDENCIES (trivial-gray-streams alexandria) VERSION babel-20150608-git SIBLINGS
    (babel-tests babel)) */
