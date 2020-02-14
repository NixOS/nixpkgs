{ stdenv, lib, fetchurl, fetchpatch, fetchFromGitHub, ocaml, findlib }:

let
  meta_file = fetchurl {
    url = https://raw.githubusercontent.com/ocaml/opam-repository/3c191ae9356ca7b3b628f2707cfcb863db42480f/packages/FrontC/FrontC.3.4.1/files/META;
    sha256 = "0s2wsinycldk8y5p09xd0hsgbhckhy7bkghzl63bph6mwv64kq2d";
  };
in

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-FrontC-${version}";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "BinaryAnalysisPlatform";
    repo = "FrontC";
    rev = "V_3_4_1";
    sha256 = "1dq5nks0c9gsbr1m8k39m1bniawr5hqcy1r8x5px7naa95ch06ak";
  };

  buildInputs = [ ocaml findlib ];

  meta = with lib; {
    inherit (src.meta) homepage;
    inherit (ocaml.meta) platforms;
    description = "C Parsing Library";
    license = licenses.lgpl21;
    maintainers = [ maintainers.maurer ];
  };

  patches = [ (fetchpatch {
      url = https://raw.githubusercontent.com/ocaml/opam-repository/3c191ae9356ca7b3b628f2707cfcb863db42480f/packages/FrontC/FrontC.3.4.1/files/opam.patch;
      sha256 = "0v4f6740jbj1kxg1y03dzfa3x3gsrhv06wpzdj30gl4ki5fvj4hs";
    })
  ];

  makeFlags = [ "PREFIX=$(out)" "OCAML_SITE=$(OCAMLFIND_DESTDIR)" ];

  postInstall = "cp ${meta_file} $OCAMLFIND_DESTDIR/FrontC/META";
}
