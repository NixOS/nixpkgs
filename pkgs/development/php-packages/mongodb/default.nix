{ buildPecl, lib, pkgs, pcre' }:

buildPecl {
  pname = "mongodb";

  version = "1.8.1";
  sha256 = "0xxrll17c7nz146g9gww4cg41xc3qg41n73syb06546q9skqabyl";

  nativeBuildInputs = [ pkgs.pkgconfig ];
  buildInputs = with pkgs; [
    cyrus_sasl
    icu64
    openssl
    snappy
    zlib
    pcre'
  ] ++ lib.optional (pkgs.stdenv.isDarwin) pkgs.darwin.apple_sdk.frameworks.Security;

  meta.maintainers = lib.teams.php.members;
}
