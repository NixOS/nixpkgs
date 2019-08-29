{ buildNimblePackage, fetchgit, rocksdb, stew, tempfile }:
let json = with builtins; fromJSON (readFile ./nimble.json);
in buildNimblePackage {
  nimbleMeta = json.nimble;
  version = "0.2.0";
  src = fetchgit { inherit (json.src) url rev sha256; };
  propagatedBuildInputs = [ rocksdb ];
  nimbleInputs = [ stew tempfile ];
  nimbleLdFlags = [ "-L${rocksdb}/lib" ];
}
