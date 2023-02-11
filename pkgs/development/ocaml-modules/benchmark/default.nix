{ stdenv, lib, fetchzip, ocaml, findlib, ocamlbuild, ocaml_pcre }:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-benchmark";
  version = "1.4";

  src = fetchzip {
    url = "https://github.com/Chris00/ocaml-benchmark/releases/download/${version}/benchmark-${version}.tar.gz";
    sha256 = "16wi8ld7c3mq77ylpgbnj8qqqqimyzwxs47v06vyrwpma5pab5xa";
  };

  strictDeps = true;

  nativeBuildInputs = [ ocaml findlib ocamlbuild ];
  buildInputs = [ ocaml_pcre ];

  createFindlibDestdir = true;

  meta = {
    homepage = "http://ocaml-benchmark.forge.ocamlcore.org/";
    inherit (ocaml.meta) platforms;
    description = "Benchmark running times of code";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ ];
  };
}
