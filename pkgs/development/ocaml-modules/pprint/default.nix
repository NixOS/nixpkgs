{stdenv, fetchurl, ocaml, findlib}:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "3.12";

stdenv.mkDerivation {

  name = "ocaml-pprint-20140424";

  src = fetchurl {
    url = http://gallium.inria.fr/~fpottier/pprint/pprint-20140424.tar.gz;
    sha256 = "0sc9q89dnyarcg24czyhr6ams0ylqvia3745s6rfwd2nldpygsdk";
  };

  buildInputs = [ ocaml findlib ];

  createFindlibDestdir = true;

  dontBuild = true;
  installFlags = "-C src";

  meta = with stdenv.lib; {
    homepage = http://gallium.inria.fr/~fpottier/pprint/;
    description = "An OCaml adaptation of Wadler’s and Leijen’s prettier printer";
    license = licenses.cecill-c;
    maintainers = [ maintainers.vbgl ];
    platforms = ocaml.meta.platforms or [];
  };
}
