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

  version = "1.14.2";
  sha256 = "1amayawrkyl1f44b8qwvm9567nxxfpv12pkn65adgjbwk5ds6z3g";

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
