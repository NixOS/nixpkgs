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
  version = "1.19.2";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongo-php-driver";
    rev = version;
    hash = "sha256-dsX7AMcbSfgzN6TfpJTaRAbhyBpOECvaok+CCOb4hyI=";
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
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk_11_0.frameworks.Security
      darwin.apple_sdk_11_0.Libsystem
      libiconv
    ];

  meta = {
    description = "The Official MongoDB PHP driver";
    homepage = "https://github.com/mongodb/mongo-php-driver";
    license = lib.licenses.asl20;
    maintainers = lib.teams.php.members;
  };
}
