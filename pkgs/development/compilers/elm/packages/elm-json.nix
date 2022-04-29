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
  version = "0.2.10";

  src = fetchurl {
    url = "https://github.com/zwilias/elm-json/archive/v${version}.tar.gz";
    sha256 = "sha256:03azh7wvl60h6w7ffpvl49s7jr7bxpladcm4fzcasakg26i5a71x";
  };

  cargoPatches = [ ./elm-json.patch ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    curl openssl
  ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  cargoSha256 = "sha256:01zasrqf1va58i52s3kwdkj1rnwy80gv00xi6npfshjirj3ix07f";

  # Tests perform networking and therefore can't work in sandbox
  doCheck = false;

  meta = with lib; {
    description = "Install, upgrade and uninstall Elm dependencies";
    homepage = "https://github.com/zwilias/elm-json";
    license = licenses.mit;
    maintainers = [ maintainers.turbomack ];
  };
}
