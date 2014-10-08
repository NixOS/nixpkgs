{stdenv, fetchurl, ocaml, findlib }:

stdenv.mkDerivation {
  name = "ocaml-twt-0.931";

  src = fetchurl {
    url = https://github.com/mlin/twt/archive/v0.931.tar.gz;
    sha256 = "0hbd4zzjwbzlhv6vcn27al236l0d0mg0jfknywdidxdxwnmd3aj2";
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
    platforms = ocaml.meta.platforms;
  };
}
