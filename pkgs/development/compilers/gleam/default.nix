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

  cargoSha256 = "0zfdsnrnxplvi4f92l7sqdp5yk5p738ra64m41izlcilkwj1j3vp";

  meta = with stdenv.lib; {
    description = "A statically typed language for the Erlang VM";
    homepage = "https://gleam.run/";
    license = licenses.asl20;
    maintainers = with maintainers; [ filalex77 ];
  };
}
