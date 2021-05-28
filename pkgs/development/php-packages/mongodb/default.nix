{ buildPecl, lib, pkgs, pcre' }:

buildPecl {
  pname = "mongodb";

  version = "1.6.1";
  sha256 = "1j1w4n33347j9kwvxwsrix3gvjbiqcn1s5v59pp64s536cci8q0m";

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
