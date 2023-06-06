{ lib, rustPlatform, fetchurl, openssl, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "elm-test-rs";
  version = "2.0";

  src = fetchurl {
    url = "https://github.com/mpizenberg/elm-test-rs/archive/v${version}.tar.gz";
    sha256 = "sha256:1manr42w613r9vyji7pxx5gb08jcgkdxv29qqylrqlwxa8d5dcid";
  };

  buildInputs = lib.optionals (!stdenv.isDarwin) [
    openssl
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    Security
    CoreServices
  ]);

  cargoSha256 = "sha256:1dpdlzv96kpc25yf5jgsz9qldghyw35x382qpxhkadkn5dryzjvd";
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "pubgrub-dependency-provider-elm-0.1.0" = "sha256-00J5XZfmuB4/fgB06aaXrRjdmOpOsSwA3dC3Li1m2Cc=";
    };
  };

  # Tests perform networking and therefore can't work in sandbox
  doCheck = false;

  meta = with lib; {
    description = "Fast and portable executable to run your Elm tests";
    homepage = "https://github.com/mpizenberg/elm-test-rs";
    license = licenses.bsd3;
    maintainers = [ maintainers.jpagex ];
  };
}
