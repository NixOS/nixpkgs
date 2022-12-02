{ lib, stdenv, fetchFromGitHub, ocaml, findlib }:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-twt";
  version = "0.94.0";

  src = fetchFromGitHub {
    owner = "mlin";
    repo = "twt";
    rev = "v${version}";
    sha256 = "sha256-xbjLPd7P1KyuC3i6WHLBcdLwd14atcBsd5ER+l97KAk=";
  };

  nativeBuildInputs = [ ocaml findlib ];

  strictDeps = true;

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $OCAMLFIND_DESTDIR
  '';

  dontBuild = true;

  installFlags = [ "PREFIX=$(out)" ];

  dontStrip = true;

  meta = with lib; {
    description = "“The Whitespace Thing” for OCaml";
    homepage = "http://people.csail.mit.edu/mikelin/ocaml+twt/";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
    mainProgram = "ocaml+twt";
    inherit (ocaml.meta) platforms;
  };
}
