{stdenv, fetchurl, ocaml, findlib}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  version = "0.8.3";
in

stdenv.mkDerivation {
  name = "camomile-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/camomile/camomile-${version}.tar.bz2";
    #sha256 = "0x43pjxx70kgip86mmdn08s97k4qzdqc8i79xfyyx28smy1bsa00";
    sha256 = "0yzj6j88aqrkbcynqh1d7r54670m1sqf889vdcgk143w85fxdj4l";
  };

  buildInputs = [ocaml findlib];

  createFindlibDestdir = true;

  meta = {
    homepage = http://camomile.sourceforge.net/;
    description = "A comprehensive Unicode library for OCaml";
    license = "LGPL";
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
