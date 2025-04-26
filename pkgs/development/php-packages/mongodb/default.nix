{
  stdenv,
  buildPecl,
  fetchFromGitHub,
  lib,
  libiconv,
  pcre2,
  pkg-config,
  cyrus_sasl,
  icu64,
  openssl,
  snappy,
  zlib,
  darwin,
}:

buildPecl rec {
  pname = "mongodb";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongo-php-driver";
    rev = version;
    hash = "sha256-o4fy46oh3iWLAcszcFo1m5GdalQs6OswT+OQTYo2cZc=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [
      cyrus_sasl
      icu64
      openssl
      snappy
      zlib
      pcre2
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk_11_0.frameworks.Security
      darwin.apple_sdk_11_0.Libsystem
      libiconv
    ];

  meta = {
    description = "Official MongoDB PHP driver";
    homepage = "https://github.com/mongodb/mongo-php-driver";
    license = lib.licenses.asl20;
    teams = [ lib.teams.php ];
  };
}
