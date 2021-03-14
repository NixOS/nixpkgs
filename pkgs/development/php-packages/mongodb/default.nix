{ stdenv, buildPecl, lib, pcre', pkg-config, cyrus_sasl, icu64
, openssl, snappy, zlib, darwin }:

buildPecl {
  pname = "mongodb";

  version = "1.9.0";
  sha256 = "16mbw3p80qxsj86nmjbfch8wv6jaq8wbz4rlpmixvhj9nwbp37hs";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    cyrus_sasl
    icu64
    openssl
    snappy
    zlib
    pcre'
  ] ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  meta.maintainers = lib.teams.php.members;
}
