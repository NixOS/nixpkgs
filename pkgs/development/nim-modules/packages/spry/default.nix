{ buildNimblePackage, fetchgit, pkgconfig, spryvm, openssl, sqlite, gtk3 }:
let json = with builtins; fromJSON (readFile ./nimble.json);
in buildNimblePackage {
  nimbleMeta = json.nimble;
  version = "0.8.0";
  src = fetchgit { inherit (json.src) url rev sha256; };

  nativeBuildInputs = [ pkgconfig ];
  nimbleInputs = [ spryvm ];
  buildInputs = [ openssl sqlite ];

  NIX_LDFLAGS = [ "-lcrypto" "-lsqlite3" ];

}
