{ buildNimblePackage, fetchgit, snappy }:
let json = with builtins; fromJSON (readFile ./nimble.json);
in buildNimblePackage {
  nimbleMeta = json.nimble;
  version = "0.1.0";
  src = fetchgit { inherit (json.src) url rev sha256; };
  propagatedBuildInputs = [ snappy ];
}
