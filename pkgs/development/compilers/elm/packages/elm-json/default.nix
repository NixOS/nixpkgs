{ lib
, curl
, rustPlatform
, fetchurl
, openssl
, stdenv
, pkg-config
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "elm-json";
  version = "0.2.12";

  src = fetchurl {
    url = "https://github.com/zwilias/elm-json/archive/v${version}.tar.gz";
    sha256 = "sha256:nlpxlPzWk3wwDgczuMI9T6DFY1YtQpQ1R4BhdPbzZBs=";
  };

  cargoPatches = [ ./use-system-ssl.patch ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    curl
    openssl
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  cargoHash = "sha256-8SOpL8nfhYen9vza0LYpB/5fgVmBwG7vGMmFOaJskIc=";

  # Tests perform networking and therefore can't work in sandbox
  doCheck = false;

  meta = with lib; {
    description = "Install, upgrade and uninstall Elm dependencies";
    mainProgram = "elm-json";
    homepage = "https://github.com/zwilias/elm-json";
    license = licenses.mit;
    maintainers = [ maintainers.turbomack ];
  };
}
