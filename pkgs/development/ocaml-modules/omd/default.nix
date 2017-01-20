{ stdenv, fetchurl, ocaml, findlib, ocamlbuild }:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-omd-1.3.0";
  src = fetchurl {
    url = http://pw374.github.io/distrib/omd/omd-1.3.0.tar.gz;
    sha256 = "0d0r6c4s3hq11d0qjc0bc1s84hz7k8nfg5q6g239as8myam4a80w";
  };

  buildInputs = [ ocaml findlib ocamlbuild ];

  createFindlibDestdir = true;

  configurePhase = "ocaml setup.ml -configure --prefix $out";

  meta = {
    description = "Extensible Markdown library and tool in OCaml";
    homepage = https://github.com/ocaml/omd;
    license = stdenv.lib.licenses.isc;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
