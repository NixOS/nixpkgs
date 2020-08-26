{ rustPlatform, fetchurl, openssl, stdenv, pkg-config }:
rustPlatform.buildRustPackage rec {
  pname = "elm-json";
  version = "0.2.7";

  src = fetchurl {
    url = "https://github.com/zwilias/elm-json/archive/v${version}.tar.gz";
    sha256 = "sha256:1b9bhl7rb01ylqjbfd1ccm26lhk4hzwd383rbg89aj2jwjv0w4hs";
  };

  cargoPatches = [ ./elm-json.patch ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  cargoSha256 = "0ylniriq073kpiykamkn9mxdaa6kyiza4pvf7gnfq2h1dvbqa6z7";

  # Tests perform networking and therefore can't work in sandbox
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Install, upgrade and uninstall Elm dependencies";
    homepage = "https://github.com/zwilias/elm-json";
    license = licenses.mit;
    maintainers = [ maintainers.turbomack ];
    platforms = platforms.linux;
  };
}
