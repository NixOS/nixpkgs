{ lib, fetchFromGitHub, stdenv
, findlib, ocaml, ocamlbuild
}:

lib.throwIf (lib.versionOlder ocaml.version "4.02")
  "sosa is not available for OCaml ${ocaml.version}"

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-sosa";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "hammerlab";
    repo = "sosa";
    rev = "sosa.${version}";
    sha256 = "053hdv6ww0q4mivajj4iyp7krfvgq8zajq9d8x4mia4lid7j0dyk";
  };

  postPatch = lib.optionalString (lib.versionAtLeast ocaml.version "4.07") ''
    for p in functors list_of of_mutable
    do
      substituteInPlace src/lib/$p.ml --replace Pervasives. Stdlib.
    done
  '';

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
