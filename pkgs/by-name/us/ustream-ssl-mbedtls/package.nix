{
  ustream-ssl,
  mbedtls,
}:

ustream-ssl.override {
  ssl_implementation = mbedtls;
}
