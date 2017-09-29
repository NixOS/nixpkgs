{stdenv, fetchurl, which, perl, ocaml, findlib, javalib, camlp4 }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "3.12";

let
  pname = "sawja";
  version = "1.5.2";
  webpage = "http://sawja.inria.fr/";
in
stdenv.mkDerivation rec {

  name = "ocaml${ocaml.version}-${pname}-${version}";

  src = fetchurl {
    url = https://gforge.inria.fr/frs/download.php/file/36093/sawja-1.5.2.tar.bz2;
    sha256 = "12046arkxiy4gf1s17hyc0yzydjzpzwqxn13sbkbxl8xzvmankx4";
  };

  buildInputs = [ which perl ocaml findlib camlp4 ];

  patches = [ ./configure.sh.patch ./Makefile.config.example.patch ];

  createFindlibDestdir = true;

  preConfigure = "patchShebangs ./configure.sh";

  configureScript = "./configure.sh";
  dontAddPrefix = "true";

  propagatedBuildInputs = [ javalib ];

  meta = with stdenv.lib; {
    description = "A library written in OCaml, relying on Javalib to provide a high level representation of Java bytecode programs";
    homepage = "${webpage}";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.vbgl ];
    platforms = ocaml.meta.platforms or [];
  };
}
