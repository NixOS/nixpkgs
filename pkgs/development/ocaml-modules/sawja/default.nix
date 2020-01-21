{stdenv, fetchurl, which, perl, ocaml, findlib, javalib }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "3.12";

let
  pname = "sawja";
  version = "1.5.7";
  webpage = "http://sawja.inria.fr/";
in
stdenv.mkDerivation {

  name = "ocaml${ocaml.version}-${pname}-${version}";

  src = fetchurl {
    url = https://gforge.inria.fr/frs/download.php/file/38117/sawja-1.5.7.tar.bz2;
    sha256 = "08xv1bq4pragc1g93w4dnbn0mighcjwfp3ixj9jzmhka2vzqm4cc";
  };

  buildInputs = [ which perl ocaml findlib ];

  patches = [ ./configure.sh.patch ./Makefile.config.example.patch ];

  createFindlibDestdir = true;

  preConfigure = "patchShebangs ./configure.sh";

  configureScript = "./configure.sh";
  dontAddPrefix = "true";

  propagatedBuildInputs = [ javalib ];

  meta = with stdenv.lib; {
    description = "A library written in OCaml, relying on Javalib to provide a high level representation of Java bytecode programs";
    homepage = webpage;
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.vbgl ];
    platforms = ocaml.meta.platforms or [];
  };
}
