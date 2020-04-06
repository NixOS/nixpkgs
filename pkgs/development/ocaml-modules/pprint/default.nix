{ stdenv, fetchurl, ocaml, findlib, ocamlbuild }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "3.12";

let param =
  if stdenv.lib.versionAtLeast ocaml.version "4.02"
  then {
    version = "20171003";
    sha256 = "06zwsskri8kaqjdszj9360nf36zvwh886xwf033aija8c9k4w6cx";
  } else {
    version = "20140424";
    sha256 = "0sc9q89dnyarcg24czyhr6ams0ylqvia3745s6rfwd2nldpygsdk";
}; in

stdenv.mkDerivation {

  name = "ocaml${ocaml.version}-pprint-${param.version}";

  src = fetchurl {
    url = "http://gallium.inria.fr/~fpottier/pprint/pprint-${param.version}.tar.gz";
    inherit (param) sha256;
  };

  buildInputs = [ ocaml findlib ocamlbuild ];

  createFindlibDestdir = true;

  dontBuild = true;
  installFlags = [ "-C" "src" ];

  meta = with stdenv.lib; {
    homepage = http://gallium.inria.fr/~fpottier/pprint/;
    description = "An OCaml adaptation of Wadler’s and Leijen’s prettier printer";
    license = licenses.cecill-c;
    maintainers = [ maintainers.vbgl ];
    platforms = ocaml.meta.platforms or [];
  };
}
