{ stdenv, rustPlatform, fetchFromGitHub, Security }:

rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    rev = "v${version}";
    sha256 = "0r0xpgvn9q84bw890qjc0r65fjisy0892xdvjnyv7v4d5g0s34zc";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "02f8jag6l0ah4lqc4cq4vymbxjf4l90dvf1kcqp7fcyq2cdqflrk";

  meta = with stdenv.lib; {
    description = "A statically typed language for the Erlang VM";
    homepage = "https://gleam.run/";
    license = licenses.asl20;
    maintainers = with maintainers; [ filalex77 ];
  };
}
