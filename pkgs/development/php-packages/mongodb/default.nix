{ stdenv
, buildPecl
, lib
, pcre2
, pkg-config
, cyrus_sasl
, icu64
, openssl
, snappy
, zlib
, darwin
}:

buildPecl {
  pname = "mongodb";

  version = "1.11.1";
  sha256 = "sha256-g4pQUN5Q1R+VkCa9jOxzSdivNwWMD+BylaC8lgqC1+8=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    cyrus_sasl
    icu64
    openssl
    snappy
    zlib
    pcre2
  ] ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  meta = with lib; {
    description = "MongoDB driver for PHP";
    license = licenses.asl20;
    homepage = "https://docs.mongodb.com/drivers/php/";
    maintainers = teams.php.members;
  };
}
