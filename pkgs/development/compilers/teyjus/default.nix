{ stdenv, fetchurl, omake, ocaml, flex, bison }:

stdenv.mkDerivation {
  name = "teyjus-2.1";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/teyjus/teyjus-source-2.0-b2.tar.gz";
    sha256 = "0llhm5nrfyj7ihz2qq1q9ijrh6y4f8vl39mpfkkad5bh1m3gp2gm";
  };

  patches = [ ./fix-lex-to-flex.patch ];

  buildInputs = [ omake ocaml flex bison ];

  hardeningDisable = [ "format" ];

  buildPhase = "omake all";

  checkPhase = "omake check";

  installPhase = "mkdir -p $out/bin && cp tj* $out/bin";

  meta = with stdenv.lib; {
    description = "An efficient implementation of the Lambda Prolog language";
    homepage = https://github.com/teyjus/teyjus;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ maintainers.bcdarwin ];
    platforms = platforms.linux;
  };
}
