{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, type_conv, camlp4 }:

assert stdenv.lib.versionOlder "4.00" (stdenv.lib.getVersion ocaml);

if stdenv.lib.versionAtLeast ocaml.version "4.06"
then throw "fieldslib-109.20.03 is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation {
  name = "ocaml-fieldslib-109.20.03";

  src = fetchurl {
    url = https://ocaml.janestreet.com/ocaml-core/109.20.00/individual/fieldslib-109.20.03.tar.gz;
    sha256 = "1dkzk0wf26rhvji80dz1r56dp6x9zqrnp87wldd4pj56jli94vir";
  };

  buildInputs = [ ocaml findlib ocamlbuild ];
  propagatedBuildInputs = [ type_conv camlp4 ];

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    homepage = https://ocaml.janestreet.com/;
    description = "OCaml syntax extension to define first class values representing record fields, to get and set record fields, iterate and fold over all fields of a record and create new record values";
    license = licenses.asl20;
    maintainers = [ maintainers.vbgl ];
    platforms = ocaml.meta.platforms or [];
  };
}
