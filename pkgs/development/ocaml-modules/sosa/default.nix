{ lib, fetchFromGitHub, stdenv
, findlib, ocaml, ocamlbuild
}:

if !lib.versionAtLeast ocaml.version "4.02"
then throw "sosa is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-sosa";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "hammerlab";
    repo = "sosa";
    rev = "sosa.${version}";
    sha256 = "053hdv6ww0q4mivajj4iyp7krfvgq8zajq9d8x4mia4lid7j0dyk";
  };

  nativeBuildInputs = [ ocaml ocamlbuild findlib ];

  strictDeps = true;

  buildPhase = "make build";

  createFindlibDestdir = true;

  doCheck = true;

  meta = with lib; {
    homepage = "http://www.hammerlab.org/docs/sosa/master/index.html";
    description = "Sane OCaml String API";
    license = licenses.isc;
    maintainers = [ maintainers.alexfmpe ];
  };
}
