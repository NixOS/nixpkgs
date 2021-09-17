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

  version = "1.9.1";
  sha256 = "1mzyssy2a89grw7rwmh0x22lql377nmnqlcv9piam1c32qiwxlg9";

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
