{ stdenv, buildOcaml, ocaml, fetchurl }:

if stdenv.lib.versionAtLeast ocaml.version "4.06"
then throw "estring is not available for OCaml ${ocaml.version}"
else

buildOcaml rec {
  name = "estring";
  version = "1.3";

  src = fetchurl {
    url = "https://forge.ocamlcore.org/frs/download.php/1012/estring-${version}.tar.gz";
    sha256 = "0b6znz5igm8pp28w4b7sgy82rpd9m5aw6ss933rfbw1mrh05gvcg";
  };

  meta = with stdenv.lib; {
    homepage = http://estring.forge.ocamlcore.org/;
    description = "Extension for string literals";
    license = licenses.bsd3;
  };
}
