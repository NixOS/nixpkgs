# Setup paths needed by avrgcc-unwrapped
{ stdenv, writeText, makeWrapper, avrgcc-unwrapped, avrlibc }:
stdenv.mkDerivation rec {
  name = "avr-gcc-wrapper-${version}";
  version = stdenv.lib.strings.getVersion avrgcc-unwrapped.name;
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ avrgcc-unwrapped avrlibc ];
  builder = writeText "builder.sh" ''
    source $stdenv/setup
    mkdir -p $out/bin $out/lib
    for exe in gcc g++; do
      makeWrapper "${avrgcc-unwrapped}/bin/avr-$exe" "$out/bin/avr-$exe" --add-flags "-B${avrlibc}/avr/lib -isystem ${avrlibc}/avr/include"
    done
    ln -s ${avrgcc-unwrapped}/lib/* $out/lib
  '';
  meta = with stdenv.lib; {
    description = "GNU Compiler Collection, version ${version} for AVR microcontrollers";
    license = licenses.gpl3Plus;
    platforms = with platforms; linux ++ darwin;
  };
}
