{ stdenv, fetchzip, fpc , lang ? "en" } :
assert stdenv.lib.assertOneOf "lang" lang ["cn" "de" "en" "fr" "tr"];
stdenv.mkDerivation rec {
  pname = "gavrasm";
  version = "4.5";

  src = fetchzip {
    url ="http://www.avr-asm-tutorial.net/gavrasm/v45/gavrasm_sources_lin_45.zip";
    sha256 = "1f5g5ran74pznwj4g7vfqh2qhymaj3p26f2lvzbmlwq447iid52c";
    stripRoot=false;
  };

  nativeBuildInputs = [ fpc ];

  configurePhase = ''
    cp gavrlang_${lang}.pas gavrlang.pas
  '';

  buildPhase = ''
    fpc gavrasm.pas
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp gavrasm $out/bin
    mkdir -p $out/doc
    cp instr.asm $out/doc
    cp ReadMe.Txt $out/doc
    cp LiesMich.Txt $out/doc
  '';

  meta = with stdenv.lib; {
    homepage = http://www.avr-asm-tutorial.net/gavrasm;
    description = "AVR Assembler for ATMEL AVR-Processors";
    license = licenses.unfree;
    maintainers = with maintainers; [ mafo ];
    platforms = platforms.linux;
  };
}
