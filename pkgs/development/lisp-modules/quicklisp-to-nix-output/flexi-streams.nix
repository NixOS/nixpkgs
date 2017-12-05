args @ { fetchurl, ... }:
rec {
  baseName = ''flexi-streams'';
  version = ''1.0.15'';

  description = ''Flexible bivalent streams for Common Lisp'';

  deps = [ args."trivial-gray-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/flexi-streams/2015-07-09/flexi-streams-1.0.15.tgz'';
    sha256 = ''0zkx335winqs7xigbmxhhkhcsfa9hjhf1q6r4q710y29fbhpc37p'';
  };
    
  packageName = "flexi-streams";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/flexi-streams[.]asd${"$"}' |
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
/* (SYSTEM flexi-streams DESCRIPTION Flexible bivalent streams for Common Lisp SHA256 0zkx335winqs7xigbmxhhkhcsfa9hjhf1q6r4q710y29fbhpc37p URL
    http://beta.quicklisp.org/archive/flexi-streams/2015-07-09/flexi-streams-1.0.15.tgz MD5 02dbb5a0c5f982e0c7a88aad9a25004e NAME flexi-streams TESTNAME NIL
    FILENAME flexi-streams DEPS ((NAME trivial-gray-streams FILENAME trivial-gray-streams)) DEPENDENCIES (trivial-gray-streams) VERSION 1.0.15 SIBLINGS NIL) */
