{ stdenv, fetchurl, ocaml, findlib, camlp4, ounit, gettext, fileutils, camomile }:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-gettext-${version}";
  version = "0.3.8";

  src = fetchurl {
    url = "https://forge.ocamlcore.org/frs/download.php/1731/ocaml-gettext-${version}.tar.gz";
    sha256 = "05wnpxwzzpn2qinah2wb5wzfh5iz8gyf8jyihdbjxc8mk4hf70qv";
  };

  propagatedBuildInputs = [ gettext fileutils camomile ];

  buildInputs = [ ocaml findlib camlp4 ounit ];

  postPatch = stdenv.lib.optionalString (camlp4 != null) ''
    substituteInPlace test/test.ml                  --replace "+camlp4" "${camlp4}/lib/ocaml/${ocaml.version}/site-lib/camlp4"
    substituteInPlace ocaml-gettext/OCamlGettext.ml --replace "+camlp4" "${camlp4}/lib/ocaml/${ocaml.version}/site-lib/camlp4"
    substituteInPlace ocaml-gettext/Makefile        --replace "+camlp4" "${camlp4}/lib/ocaml/${ocaml.version}/site-lib/camlp4"
    substituteInPlace ocaml-gettext/Makefile        --replace "unix.cma" ""
    substituteInPlace libgettext-ocaml/Makefile     --replace "+camlp4" "${camlp4}/lib/ocaml/${ocaml.version}/site-lib/camlp4"
    substituteInPlace libgettext-ocaml/Makefile     --replace "\$(shell ocamlc -where)" "${camlp4}/lib/ocaml/${ocaml.version}/site-lib"
  '';

  configureFlags = [ "--disable-doc" ];

  createFindlibDestdir = true;

  dontStrip = true;

  meta = with stdenv.lib; {
    description = "OCaml Bindings to gettext";
    homepage = https://forge.ocamlcore.org/projects/ocaml-gettext;
    license = licenses.gpl2;
    maintainers = [ maintainers.volth ];
    platforms = ocaml.meta.platforms or [];
  };
}
