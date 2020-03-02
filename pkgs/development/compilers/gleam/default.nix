{ stdenv, rustPlatform, fetchFromGitHub, Security }:

rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    rev = "v${version}";
    sha256 = "1l9fdghjgyfc0dxqy3jj0hy7v325ypfj5qd1s4ns0kvy4zn0dzp7";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "0xsna9g5cinkwa3x571rmakc2i68ggwg151rfq8c07wwgp536129";

  meta = with stdenv.lib; {
    description = "A statically typed language for the Erlang VM";
    homepage = "https://gleam.run/";
    license = licenses.asl20;
    maintainers = with maintainers; [ filalex77 ];
  };
}
