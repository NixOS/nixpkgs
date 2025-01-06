{
  stdenv,
  lib,
  fetchurl,
  ocaml,
  findlib,
  ounit,
}:

# https://github.com/bmeurer/ocamlnat/issues/3
assert lib.versionOlder ocaml.version "4";

stdenv.mkDerivation rec {
  pname = "ocamlnat";
  version = "0.1.1";

  src = fetchurl {
    url = "http://benediktmeurer.de/files/source/${pname}-${version}.tar.bz2";
    sha256 = "0dyvy0j6f47laxhnadvm71z1py9hz9zd49hamf6bij99cggb2ij1";
  };

  nativeBuildInputs = [
    ocaml
    findlib
  ];
  checkInputs = [ ounit ];

  strictDeps = true;

  prefixKey = "--prefix ";

  doCheck = true;

  checkTarget = "test";

  createFindlibDestdir = true;

  meta = {
    description = "OCaml native toplevel";
    homepage = "http://benediktmeurer.de/ocamlnat/";
    license = lib.licenses.qpl;
    longDescription = ''
      The ocamlnat project provides a new native code OCaml toplevel
      ocamlnat, which is mostly compatible to the byte code toplevel ocaml,
      but up to 100 times faster. It is based on the optimizing native code
      compiler, the native runtime and an earlier prototype by Alain
      Frisch. It is build upon Just-In-Time techniques and currently
      supports Unix-like systems (i.e. Linux, BSD or macOS) running on
      x86 or x86-64 processors. Support for additional architectures and
      operating systems is planned, but not yet available.
    '';
    inherit (ocaml.meta) platforms;
    maintainers = [
      lib.maintainers.maggesi
    ];
  };
}
