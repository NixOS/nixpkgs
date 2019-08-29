{ buildNimblePackage, fetchgit, pkgconfig, gtk3, libui }:
let json = with builtins; fromJSON (readFile ./nimble.json);
in (buildNimblePackage {
  nimbleMeta = json.nimble;
  version = "0.9.4";
  src = fetchgit { inherit (json.src) url rev sha256 fetchSubmodules; };
}) // {
  propagatedBuildInputs = [ gtk3 libui ];
}
