{ stdenv, fetchzip, ocaml, findlib, jbuilder, configurator, cstruct }:

let version = "2.0.1"; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-io-page-${version}";

  src = fetchzip {
    url = "https://github.com/mirage/io-page/archive/${version}.tar.gz";
    sha256 = "1rw04dwrlx5hah5dkjf7d63iff82j9cifr8ifjis5pdwhgwcff8i";
  };

  buildInputs = [ ocaml findlib jbuilder configurator ];
  propagatedBuildInputs = [ cstruct ];

  inherit (jbuilder) installPhase;

  meta = {
    homepage = https://github.com/mirage/io-page;
    inherit (ocaml.meta) platforms;
    license = stdenv.lib.licenses.isc;
    description = "IO memory page library for Mirage backends";
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
