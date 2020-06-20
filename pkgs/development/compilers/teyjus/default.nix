{ stdenv, fetchurl, omake, ocaml, flex, bison }:

let
  version = "2.1";
in

stdenv.mkDerivation {
  pname = "teyjus";
  inherit version;

  src = fetchurl {
    url = "https://github.com/teyjus/teyjus/archive/v${version}.tar.gz";
    sha256 = "0393wpg8v1vvarqy2xh4fdmrwlrl6jaj960kql7cq79mb9p3m269";
  };

  patches = [ ./fix-lex-to-flex.patch ];

  buildInputs = [ omake ocaml flex bison ];

  hardeningDisable = [ "format" ];

  buildPhase = "omake all";

  checkPhase = "omake check";

  installPhase = "mkdir -p $out/bin && cp tj* $out/bin";

  meta = with stdenv.lib; {
    description = "An efficient implementation of the Lambda Prolog language";
    homepage = "https://github.com/teyjus/teyjus";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ maintainers.bcdarwin ];
    platforms = platforms.linux;
  };
}
