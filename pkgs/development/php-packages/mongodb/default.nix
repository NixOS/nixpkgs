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
}:

buildPecl rec {
  pname = "mongodb";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongo-php-driver";
    rev = version;
    hash = "sha256-hvkC0fBONDhgozTfEM0xdlDSY9VM4O1qCgJKEwWOdH0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    cyrus_sasl
    icu64
    openssl
    snappy
    zlib
    pcre2
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  meta = {
    description = "Official MongoDB PHP driver";
    homepage = "https://github.com/mongodb/mongo-php-driver";
    license = lib.licenses.asl20;
    teams = [ lib.teams.php ];
  };
}
