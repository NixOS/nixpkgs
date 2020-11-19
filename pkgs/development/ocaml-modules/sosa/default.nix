{ lib, fetchFromGitHub, stdenv
, findlib, nonstd, ocaml, ocamlbuild
}:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-sosa-${version}";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "hammerlab";
    repo = "sosa";
    rev = "sosa.${version}";
    sha256 = "053hdv6ww0q4mivajj4iyp7krfvgq8zajq9d8x4mia4lid7j0dyk";
  };

  buildInputs = [ nonstd ocaml ocamlbuild findlib ];

  buildPhase = "make build";

  createFindlibDestdir = true;

  doCheck = true;

  meta = with lib; {
    homepage = http://www.hammerlab.org/docs/sosa/master/index.html;
    description = "Sane OCaml String API";
    license = licenses.isc;
    maintainers = [ maintainers.alexfmpe ];
  };
}
