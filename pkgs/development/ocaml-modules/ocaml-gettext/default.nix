{ stdenv, fetchurl, ocaml, findlib, camlp4, ounit, gettext, fileutils, camomile }:

stdenv.mkDerivation rec {
  name = "ocaml-gettext-${version}";
  version = "0.3.5";

  src = fetchurl {
    url = "https://forge.ocamlcore.org/frs/download.php/1433/ocaml-gettext-${version}.tar.gz";
    sha256 = "0s625h7y9xxqvzk4bnw45k4wvl4fn8gblv56bp47il0lgsx8956i";
  };

  propagatedBuildInputs = [ gettext fileutils camomile ];

  buildInputs = [ ocaml findlib camlp4 ounit ];

  configureFlags = [ "--disable-doc" ];

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    description = "OCaml Bindings to gettext";
    homepage = https://forge.ocamlcore.org/projects/ocaml-gettext;
    license = licenses.gpl2;
    maintainers = [ maintainers.volth ];
    platforms = ocaml.meta.platforms or [];
  };
}
