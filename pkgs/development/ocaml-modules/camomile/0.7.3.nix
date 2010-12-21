{stdenv, fetchurl, ocaml, findlib}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  version = "0.7.3";
in

stdenv.mkDerivation {
  name = "camomile-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/camomile/camomile-${version}.tar.bz2";
    sha256 = "0cm3j3ppl15fp597ih3qiagxyg8kpql9apapkqaib2xccc44zb5l";
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
