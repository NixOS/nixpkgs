{ stdenv, fetchzip, ocaml, findlib }:

stdenv.mkDerivation {
  name = "ocaml-twt-0.94.0";

  src = fetchzip {
    url = https://github.com/mlin/twt/archive/v0.94.0.tar.gz;
    sha256 = "0298gdgzl4cifxnc1d8sbrvz1lkiq5r5ifkq1fparm6gvqywpf65";
  };

  buildInputs = [ ocaml findlib ];

  createFindlibDestdir = true;

  configurePhase = ''
    mkdir $out/bin
  '';

  dontBuild = true;

  installFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    homepage = http://people.csail.mit.edu/mikelin/ocaml+twt/;
    description = "“The Whitespace Thing” for OCaml";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
    platforms = ocaml.meta.platforms or [];
  };
}
