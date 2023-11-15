{ lib, rustPlatform, fetchurl, openssl, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "elm-test-rs";
  version = "3.0";

  src = fetchurl {
    url = "https://github.com/mpizenberg/elm-test-rs/archive/v${version}.tar.gz";
    sha256 = "sha256-nrX+jb/fKwoQSmQTim3sew0uGg5+nscL22YP5lkFyls=";
  };

  buildInputs = lib.optionals (!stdenv.isDarwin) [
    openssl
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    Security
    CoreServices
  ]);

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
    mainProgram = "elm-test-rs";
    homepage = "https://github.com/mpizenberg/elm-test-rs";
    license = licenses.bsd3;
    maintainers = [ maintainers.jpagex maintainers.zupo ];
  };
}
