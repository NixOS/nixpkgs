{ stdenv, fetchurl, libvirt, ocaml, findlib }:

stdenv.mkDerivation rec {
  name = "ocaml-libvirt-${version}";
  version = "0.6.1.4";

  src = fetchurl {
    url = "http://libvirt.org/sources/ocaml/ocaml-libvirt-${version}.tar.gz";
    sha256 = "06q2y36ckb34n179bwczxkl82y3wrba65xb2acg8i04jpiyxadjd";
  };

  propagatedBuildInputs = [ libvirt ];

  buildInputs = [ ocaml findlib ];

  createFindlibDestdir = true;

  buildPhase = if stdenv.cc.isClang then "make all opt CPPFLAGS=-Wno-error" else "make all opt";

  installPhase = "make install-opt";

  meta = with stdenv.lib; {
    description = "OCaml bindings for libvirt";
    homepage = https://libvirt.org/ocaml/;
    license = licenses.gpl2;
    maintainers = [ maintainers.volth ];
    platforms = ocaml.meta.platforms or [];
  };
}
