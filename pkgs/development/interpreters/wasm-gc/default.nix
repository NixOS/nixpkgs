{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "wasm-gc-${version}";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "alexcrichton";
    repo = "wasm-gc";
    rev = version;
    sha256 = "1lc30xxqp3vv1r269xzznh2lf2dzdq89bi5f1vmqjw4yc3xmawm7";
  };

  cargoPatches = [ ./fix-build.patch ]; # Cargo.lock is not up-to-date

  cargoSha256 = "1jvk9n324p3x3j6q6x0p5diig3b5c683k74cfflff25i7gsmmvc7";

  meta = with stdenv.lib; {
    description = "gc-sections for wasm";
    homepage = "https://github.com/alexcrichton/wasm-gc";
    maintainers = with maintainers; [ ekleog ];
    platforms = platforms.all;
    license = with licenses; [ mit asl20 ];
  };
}
