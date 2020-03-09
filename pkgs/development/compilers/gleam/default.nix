{ stdenv, rustPlatform, fetchFromGitHub, Security }:

rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fvy2j6pw1rwm0rg7555q3qg2069cx2b9lk0nsyc3jxsqp9hbn6i";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "1vhra9v4jsy9hyhjrmxjy6rnraxz13h1b7l51xvbai5wxsxm7z8m";

  meta = with stdenv.lib; {
    description = "A statically typed language for the Erlang VM";
    homepage = "https://gleam.run/";
    license = licenses.asl20;
    maintainers = with maintainers; [ filalex77 ];
  };
}
