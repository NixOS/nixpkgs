{ stdenv, fetchurl, omake, ocaml, flex, bison }:

stdenv.mkDerivation {
  name = "teyjus-2.0b2";

  src = fetchurl {
    url = "https://teyjus.googlecode.com/files/teyjus-source-2.0-b2.tar.gz";
    sha256 = "f589fb460d7095a6e674b7a6413772c41b98654c38602c3e8c477a976da99052";
  };

  patches = [ ./fix-lex-to-flex.patch ];

  buildInputs = [ omake ocaml flex bison ];

  hardeningDisable = [ "format" ];

  buildPhase = "omake all";

  checkPhase = "omake check";

  installPhase = "mkdir -p $out/bin && cp tj* $out/bin";

  meta = with stdenv.lib; {
    description = "An efficient implementation of the Lambda Prolog language";
    homepage = https://code.google.com/p/teyjus/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ maintainers.bcdarwin ];
    platforms = platforms.linux;
  };
}
