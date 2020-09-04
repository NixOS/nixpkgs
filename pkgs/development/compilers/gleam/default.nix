{ stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    rev = "v${version}";
    sha256 = "1g8yfp1xpkv1lqz8azam40cvrs5cggxlyrb72h8k88br75qmi6hj";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++
    stdenv.lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "1gfr6c4i5kx8x3q23s4b4n25z2k6xkxpk12acr4ry97pyj2lr5wq";

  meta = with stdenv.lib; {
    description = "A statically typed language for the Erlang VM";
    homepage = "https://gleam.run/";
    license = licenses.asl20;
    maintainers = with maintainers; [ filalex77 ];
  };
}
