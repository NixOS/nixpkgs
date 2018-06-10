{ stdenv, fetchzip, ocaml, findlib, ocamlbuild, ocaml_pcre }:

let version = "1.4"; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-benchmark-${version}";

  src = fetchzip {
    url = "https://github.com/Chris00/ocaml-benchmark/releases/download/${version}/benchmark-${version}.tar.gz";
    sha256 = "16wi8ld7c3mq77ylpgbnj8qqqqimyzwxs47v06vyrwpma5pab5xa";
  };

  buildInputs = [ ocaml findlib ocamlbuild ocaml_pcre ];

  createFindlibDestdir = true;

  meta = {
    homepage = http://ocaml-benchmark.forge.ocamlcore.org/;
    platforms = ocaml.meta.platforms or [];
    description = "Benchmark running times of code";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ volth ];
  };
}
