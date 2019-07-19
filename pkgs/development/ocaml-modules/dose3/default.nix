{ stdenv, fetchurl, ocaml, ocamlbuild, findlib
, cppo, cudf, ocamlgraph, ocaml_extlib, re, perl }:

let base_patch_url = "https://raw.githubusercontent.com/ocaml/opam-repository/master/packages/dose3/dose3.5.0.1/files";
in

stdenv.mkDerivation rec {
  pname = "dose3";
  version = "5.0.1";

  src = fetchurl {
    url = "https://gforge.inria.fr/frs/download.php/file/36063/dose3-5.0.1.tar.gz";
    sha256 = "00yvyfm4j423zqndvgc1ycnmiffaa2l9ab40cyg23pf51qmzk2jm";
  };

  patches = [
    (fetchurl {
      url = "${base_patch_url}/0001-Install-mli-cmx-etc.patch";
      sha256 = "1cp2sjkv5psl7lpy6bziv6vihig1z09pp4xq1fdj7yz6lgz1z7xi";
    })
    (fetchurl {
      url = "${base_patch_url}/0002-dont-make-printconf.patch";
      sha256 = "0gzqm4p9p2gnn1cgl2r8m4lvzp5ap2lcdzsvi77i4p8pyzrybjnl";
    })
    (fetchurl {
      url = "${base_patch_url}/0003-Fix-for-ocaml-4.06.patch";
      sha256 = "02zxwn2hh861inc0r5707dymwh2aj9z3maqcan1cnhwfwshp59bv";
    })
    (fetchurl {
      url = "${base_patch_url}/0004-Add-unix-as-dependency-to-dose3.common-in-META.in.patch";
      sha256 = "0zdfh47bcx66b5lch5mn6lwdc67pvlwsnhvfwjrg7kiqssvgn0l1";
    })
  ];

  buildInputs = [
    ocaml
    ocamlbuild
    findlib
    cppo
    cudf
    ocamlgraph
    ocaml_extlib
    re
    perl
  ];

  makeFlags = [
    "BINDIR=$(out)/bin"
    "LIBDIR=$(out)/lib"
    "INCDIR=$(out)/include"
  ];

  createFindlibDestdir = true;

  meta = {
    description = "Dose library (part of Mancoosi tools).";
    license = stdenv.lib.licenses.lgpl3;
    homepage = "http://www.mancoosi.org/software/";
  };
}
