{ lib, rustPlatform, fetchurl, openssl, stdenv, Security, darwin }:
rustPlatform.buildRustPackage rec {
  pname = "elm-test-rs";
  version = "2.0";

  src = fetchurl {
    url = "https://github.com/mpizenberg/elm-test-rs/archive/v${version}.tar.gz";
    sha256 = "sha256:1manr42w613r9vyji7pxx5gb08jcgkdxv29qqylrqlwxa8d5dcid";
  };

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security darwin.apple_sdk.frameworks.CoreServices ];

  cargoSha256 = "sha256:1dpdlzv96kpc25yf5jgsz9qldghyw35x382qpxhkadkn5dryzjvd";
  verifyCargoDeps = true;

  # Tests perform networking and therefore can't work in sandbox
  doCheck = false;
}
