{ stdenv, fetchzip, omake, ocaml, flex, bison }:

stdenv.mkDerivation {
  name = "teyjus-2.1";

  src = fetchzip {
    url = https://github.com/teyjus/teyjus/archive/v2.1.tar.gz;
    sha256 = "064jqf68zpmvndgyhilmxfhnvx1bzm8avhgw82csj5wxw5ky6glz";
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
