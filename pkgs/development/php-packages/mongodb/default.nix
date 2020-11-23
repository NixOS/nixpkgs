{ buildPecl, lib, pkgs, pcre' }:

buildPecl {
  pname = "mongodb";

  version = "1.8.2";
  sha256 = "01l300204ph9nd7khd9qazpdbi1biqvmjqbxbngdfjk9n5d8vvzw";

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
