{ lib, stdenv, fetchFromGitHub, omake, ocaml, flex, bison }:

stdenv.mkDerivation rec {
  pname = "teyjus";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "teyjus";
    repo = "teyjus";
    rev = "v${version}";
    sha256 = "sha256-nz7jZ+GdF6mZQPzBrVD9K/RtoeuVRuhfs7vej4zDkhg=";
  };

  patches = [ ./fix-lex-to-flex.patch ];

  buildInputs = [ omake ocaml flex bison ];

  hardeningDisable = [ "format" ];

  buildPhase = "omake all";

  checkPhase = "omake check";

  installPhase = "mkdir -p $out/bin && cp tj* $out/bin";

  meta = with lib; {
    description = "An efficient implementation of the Lambda Prolog language";
    homepage = "https://github.com/teyjus/teyjus";
    license = lib.licenses.gpl3;
    maintainers = [ maintainers.bcdarwin ];
    platforms = platforms.linux;
  };
}
