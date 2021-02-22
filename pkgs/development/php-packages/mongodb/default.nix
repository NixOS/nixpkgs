{ buildPecl, lib, pkgs, pcre' }:

buildPecl {
  pname = "mongodb";

  version = "1.9.0";
  sha256 = "16mbw3p80qxsj86nmjbfch8wv6jaq8wbz4rlpmixvhj9nwbp37hs";

  nativeBuildInputs = [ pkgs.pkg-config ];
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
