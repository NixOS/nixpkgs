{ stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    rev = "v${version}";
    sha256 = "0cgs0halxhp2hh3sf0nvy5ybllhraxircxxbfj9jbs3446dzflbk";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++
    stdenv.lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "12lpxighjk3ydfa288llj6xqas7z9fbfjpwnl870189awvp2fjxx";

  meta = with stdenv.lib; {
    description = "A statically typed language for the Erlang VM";
    homepage = "https://gleam.run/";
    license = licenses.asl20;
    maintainers = with maintainers; [ filalex77 ];
  };
}
