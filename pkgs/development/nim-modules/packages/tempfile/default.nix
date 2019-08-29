{ buildNimblePackage, fetchgit }:
let json = with builtins; fromJSON (readFile ./nimble.json);
in buildNimblePackage {
  nimbleMeta = json.nimble;
  version = "0.1.2";
  src = fetchgit { inherit (json.src) url rev sha256; };
}
