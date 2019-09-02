{ stdenv,lib, fetchFromGitHub, pkgconfig, ocaml, findlib, dune, gtk3, cairo2 }:

if !lib.versionAtLeast ocaml.version "4.05"
then throw "lablgtk3 is not available for OCaml ${ocaml.version}"
else

# This package uses the dune.configurator library
# It thus needs said library to be compiled with this OCaml compiler
let __dune = dune; in
let dune = __dune.override { ocamlPackages = { inherit ocaml findlib; }; }; in

stdenv.mkDerivation rec {
  version = "3.0.beta4";
  pname = "lablgtk3";
  name = "ocaml${ocaml.version}-${pname}-${version}";

  src = fetchFromGitHub {
    owner = "garrigue";
    repo = "lablgtk";
    rev = version;
    sha256 = "1lppb7k4xb1a35i7klm9mz98hw8l2f8s7rivgzysi1sviqy1ds5d";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ocaml findlib dune gtk3 ];
  propagatedBuildInputs = [ cairo2 ];

  buildPhase = "dune build -p ${pname}";
  inherit (dune) installPhase;

  meta = {
    description = "OCaml interface to gtk+-3";
    homepage = "http://lablgtk.forge.ocamlcore.org/";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
