{ stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    rev = "v${version}";
    sha256 = "1hlbskpfqdh5avmqnry69s7x0wj6l6yaqkayx7lj6z99p58p9zrz";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++
    stdenv.lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "1djznh7v6ha4ks8l8arwwn301qclmb7iih774q5y7sbzqrv7sw0q";

  meta = with stdenv.lib; {
    description = "A statically typed language for the Erlang VM";
    homepage = "https://gleam.run/";
    license = licenses.asl20;
    maintainers = with maintainers; [ filalex77 ];
  };
}
