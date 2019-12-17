{ stdenv, rustPlatform, fetchFromGitHub, Security }:

rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "lpil";
    repo = pname;
    rev = "v${version}";
    sha256 = "17h573fm5b1f71ivyipl76p0vw7injm7j3cbg6plkfizcb1j5m7f";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "04v1gj5nmmcizyrsg6b87qsfzw2zqi57vf1zlnq8680yc54qdah9";

  meta = with stdenv.lib; {
    description = "A statically typed language for the Erlang VM";
    homepage = "https://gleam.run/";
    license = licenses.asl20;
    maintainers = with maintainers; [ filalex77 ];
  };
}
