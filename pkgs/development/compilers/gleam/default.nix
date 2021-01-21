{ stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ka1GxukX3HR40fMeiiXHguyPKrpGngG2tXDColR7eQA=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++
    stdenv.lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "sha256-/l54ezS68loljKNh7AdYMIuCiyIbsMI3jqD9ktjZLfc=";

  meta = with stdenv.lib; {
    description = "A statically typed language for the Erlang VM";
    homepage = "https://gleam.run/";
    license = licenses.asl20;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
