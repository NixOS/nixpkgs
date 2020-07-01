{ stdenv, ocaml, fetchFromGitHub, ocamlbuild, findlib, ppx_deriving_protobuf }:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-ocaml-protoc-${version}";
  version = "1.2.0";

  minimumOCamlVersion = "4.02";

  src = fetchFromGitHub {
    owner = "mransan";
    repo = "ocaml-protoc";
    rev = "60d2d4dd55f73830e1bed603cc44d3420430632c";
    sha256 = "1d1p8ch723z2qa9azmmnhbcpwxbpzk3imh1cgkjjq4p5jwzj8amj";
  };

  installPhase = ''
    mkdir -p tmp/bin
    export PREFIX=`pwd`/tmp
    make all.install.build
    make check_install
    make lib.install
    make bin.install
  '';

  buildInputs = [ ocaml findlib ocamlbuild ];
  propagatedBuildInputs = [ ppx_deriving_protobuf ];

  createFindlibDestdir = true;

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/mransan/ocaml-protoc";
    description = "A Protobuf Compiler for OCaml";
    license = licenses.mit;
    maintainers = [ maintainers.vyorkin ];
  };
}
