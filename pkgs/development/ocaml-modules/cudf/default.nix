{ lib, fetchurl, stdenv, ocaml, ocamlbuild, findlib, extlib, glib, perl, pkg-config, stdlib-shims, ounit }:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-cudf";
  version = "0.9";

  src = fetchurl {
    url = "https://gforge.inria.fr/frs/download.php/36602/cudf-0.9.tar.gz";
    sha256 = "sha256-mTLk2V3OI1sUNIYv84nM3reiirf0AuozG5ZzLCmn4Rw=";
  };

  buildFlags = [
    "all"
    "opt"
  ];

  nativeBuildInputs = [
    findlib
    ocaml
    ocamlbuild
    pkg-config
    perl
  ];
  buildInputs = [
    glib
    stdlib-shims
  ];
  propagatedBuildInputs = [
    extlib
  ];

  checkTarget = [
    "all"
    "test"
  ];
  checkInputs = [
    ounit
  ];
  doCheck = true;

  preInstall = "mkdir -p $OCAMLFIND_DESTDIR";
  installFlags = [ "BINDIR=$(out)/bin" ];

  meta = with lib; {
    description = "A library for CUDF format";
    homepage = "https://www.mancoosi.org/cudf/";
    downloadPage = "https://gforge.inria.fr/projects/cudf/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ ];
  };
}
