{stdenv, fetchurl, ocaml, findlib, ounit}:

stdenv.mkDerivation {
  name = "ocamlnat-0.1.1";

  src = fetchurl {
    url = http://benediktmeurer.de/files/source/ocamlnat-0.1.1.tar.bz2;
    sha256 = "0dyvy0j6f47laxhnadvm71z1py9hz9zd49hamf6bij99cggb2ij1";
  };

  buildInputs = [ocaml findlib ounit];

  prefixKey = "--prefix ";

  doCheck = true;

  checkTarget = "test";

  createFindlibDestdir = true;

  meta = {
    description = "OCaml native toplevel";
    homepage = http://benediktmeurer.de/ocamlnat/;
    license = stdenv.lib.licenses.qpl;
    longDescription = ''
      The ocamlnat project provides a new native code OCaml toplevel
      ocamlnat, which is mostly compatible to the byte code toplevel ocaml,
      but up to 100 times faster. It is based on the optimizing native code
      compiler, the native runtime and an earlier prototype by Alain
      Frisch. It is build upon Just-In-Time techniques and currently
      supports Unix-like systems (i.e. Linux, BSD or Mac OS X) running on
      x86 or x86-64 processors. Support for additional architectures and
      operating systems is planned, but not yet available.
    '';
    platforms = ocaml.meta.platforms or [];
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
