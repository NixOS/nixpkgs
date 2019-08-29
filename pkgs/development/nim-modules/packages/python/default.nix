{ buildNimblePackage, fetchgit, python2 }:
let
  json = with builtins; fromJSON (readFile ./nimble.json);
  python = python2;
in buildNimblePackage {
  nimbleMeta = json.nimble;
  version = "1.2";
  src = fetchgit { inherit (json.src) url rev sha256; };
  patches = [ ./patch ];
  nimbleLdFlags = [ "-L${python}/lib" "-l${python.libPrefix}" ];
}
